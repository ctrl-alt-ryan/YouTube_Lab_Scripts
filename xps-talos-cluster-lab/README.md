🚀 Talos Kubernetes Cluster: XPS Mobile LabBare-metal Performance in a Portable RV Proxmox EnvironmentThis repository contains the Infrastructure as Code (IaC) manifests, Talos Linux machine configurations, and post-install setup for my 4-node (expandable to 6) Kubernetes cluster. This setup is optimized for running on Dell XPS laptops within a Proxmox VE environment.🏗️ Architecture OverviewComponentTechnologyDetailsHypervisorProxmox VE 8.xRunning on repurposed Dell XPS LaptopsOSTalos LinuxSecurity-focused, Immutable, No SSHControl Plane3 Nodes (HA)VIP: 10.3.150.200Workers3 NodesDynamic scaling based on loadCNICiliumL2 Announcements, Kube-Proxy replacementStorageSynology NFSnfs-subdir-external-provisioner🔧 Installation & Workflow1. PrerequisitesEnsure you have talosctl and kubectl installed on your management machine:Bash# Install talosctl
curl -L https://github.com/siderolabs/talos/releases/latest/download/talosctl-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64 -o /usr/local/bin/talosctl
chmod +x /usr/local/bin/talosctl

# Install kubectl (Fedora/RHEL example)
sudo dnf install -y kubernetes-client
2. Machine Configuration & PatchingI use a Multi-Layer Patching Strategy to maintain a "Dry" configuration. This allows me to apply global policies while maintaining unique host identities (IPs/Hostnames).The Merge Strategy:Bash# Generate the base config
talosctl gen config xps-talos-cluster https://10.3.150.200:6443

# Merge Base + Global Patch + Host Specific Identity
talosctl machineconfig patch controlplane.yaml \
  --patch @global-patch.yaml \
  --patch @cp-specific-patch.yaml \
  --patch @ctlr1.yaml \
  -o final-ctlr1.yaml
3. DeploymentOnce the Talos ISO is booted in Proxmox and has a DHCP IP:Bash# Push the final config to the node
talosctl apply-config --insecure --nodes <DHCP_IP> --file final-ctlr1.yaml

# Bootstrap the cluster (ONLY run on the first control plane node)
talosctl bootstrap --nodes 10.3.150.201 --endpoints 10.3.150.200
🌐 Post-Install Networking (Cilium)To enable LoadBalancer support in a home lab environment without BGP, we use Cilium with L2 Announcements.Bash# Install Cilium with Kube-Proxy replacement
cilium install \
  --namespace kube-system \
  --set ipam.mode=kubernetes \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost=10.3.150.201 \
  --set k8sServicePort=6443 \
  --set l2announcements.enabled=true \
  --set externalIPs.enabled=true

# Enable Hubble UI for observability
cilium hubble enable --ui
💾 Persistent Storage (Synology NAS)Data is persisted to a Synology NAS via NFS.Bashhelm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=10.3.177.164 \
    --set nfs.path=/volume1/Files \
    --set storageClass.name=synology-nfs \
    --set storageClass.defaultClass=true
