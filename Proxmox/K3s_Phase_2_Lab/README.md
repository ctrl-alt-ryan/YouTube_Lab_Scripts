🚀 RV Datacenter Phase 2: High Availability & Automation

Terraform + Ansible + K3s HA (3 Controllers, 2 Workers)

This phase moves away from "Manual Clicks" and into Automated Deployment. We use Terraform to provision the VMs on Proxmox and Ansible to configure a 5-node High-Availability Kubernetes cluster.
📋 Prerequisites
1. Hardware & Environment

    Proxmox VE Host: With at least 20GB RAM and 100GB Storage available.

    Ubuntu 24.04 Template: You must have a Cloud-Init enabled Ubuntu template (created in Phase 1).

    Network: Access to the 10.3.0.0/16 subnet (or modify the variables to match your home lab).

2. Software on your Workstation

    Terraform: Install Link

    Ansible: sudo dnf install ansible (Fedora) or sudo apt install ansible (Ubuntu).

    SSH Keys: An existing key pair (~/.ssh/id_rsa.pub).

🛠️ Step 1: Terraform Provisioning

    Create an API Token: In Proxmox, go to Datacenter > Permissions > API Tokens. Generate a token for your user (uncheck "Privilege Separation").

    Setup Variables: Create a terraform/terraform.tfvars file (do not commit this!):
    Terraform

    proxmox_api_url          = "https://10.3.x.x:8006/api2/json"
    proxmox_api_token_id     = "terraform-prov@pve!token_name"
    proxmox_api_token_secret = "your-secret-key-here"

    Initialize & Apply:
    Bash

    cd terraform
    terraform init
    terraform apply -auto-approve

    This will clone 5 VMs from your template and assign the IPs from 10.3.160.101 to 10.3.160.105.

🤖 Step 2: Ansible Configuration

    Verify Inventory: Open ansible/inventory.ini and ensure the ansible_user matches the user defined in your Cloud-Init template.

    Configure Variables: In ansible/deploy_k3s.yml, check the vars section for:

        vip_address: The floating IP for the cluster (default: 10.3.160.100).

        vip_interface: Usually eth0 or ens18 (check your Proxmox VMs).

    Run the Playbook:
    Bash

    cd ../ansible
    ansible-playbook -i inventory.ini deploy_k3s.yml

What this playbook does:

    Disables swap and prepares all 5 nodes.

    Initializes the first controller with embedded etcd.

    Joins the other 2 controllers to form a High-Availability Quorum.

    Deploys Kube-VIP to provide the floating IP (.100).

    Joins the 2 workers to the VIP.

    Installs MetalLB and the Monitoring Stack (Prometheus/Grafana).

✅ Step 3: Access & Verification

    Grab the Kubeconfig:
    Bash

    mkdir -p ~/.kube
    scp ryan@10.3.160.101:~/.kube/config ~/.kube/config-rv
    export KUBECONFIG=~/.kube/config-rv
    sed -i 's/127.0.0.1/10.3.160.100/g' ~/.kube/config-rv

    Check the Cluster:
    Bash

    kubectl get nodes

    You should see 5 nodes status "Ready".

    The HA Test:
    Go to Proxmox and Stop k3s-ctlr-01. Run ping 10.3.160.100. The ping should continue without interruption as the VIP moves to ctlr-02.
