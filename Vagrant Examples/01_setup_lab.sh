#!/bin/bash

echo "------------------------------------------------"
echo "Initializing Mobile-Stack Lab Deployment..."
echo "------------------------------------------------"

# 1. Environment Check
if [ ! -S /var/run/libvirt/libvirt-sock ]; then
    echo "[*] Linking Libvirt socket for host-container bridge..."
    sudo ln -sf /run/host/run/libvirt/libvirt-sock /var/run/libvirt/libvirt-sock
else
    echo "[✔] Libvirt socket already linked."
fi

# 2. Lab Directory
echo "[*] Preparing lab directory at ~/labs/mobile-stack..."
mkdir -p ~/labs/mobile-stack
cd ~/labs/mobile-stack

# 3. Permissions & Security Context
echo "[*] Applying SELinux context and directory permissions..."
# Ensure the hypervisor can traverse the path
chmod +x /var/home/ryan
# Set folder to be readable by the QEMU system process
chmod -R 755 ~/labs/mobile-stack
# Label the folder so SELinux allows the VM to access the files
sudo chcon -Rt svirt_image_t ~/labs/mobile-stack
echo "[✔] Security policies applied."

# 4. Generate the Vagrantfile
echo "[*] Generating 'No-Hang' Rsync Vagrantfile..."
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
  # Using Rsync for maximum stability on Immutable/Atomic hosts
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.vm.provider :libvirt do |libvirt|
    libvirt.uri = "qemu:///system"
    libvirt.memory = 2048
    libvirt.cpus = 2
    libvirt.cpu_mode = "host-passthrough"
  end

  # The 'Enterprise' Node
  config.vm.define "rocky-server" do |rocky|
    rocky.vm.box = "bento/rockylinux-9"
    rocky.vm.hostname = "rocky-mobile"
  end
end
EOF

echo "------------------------------------------------"
echo "Mission Ready: ~/labs/mobile-stack"
echo "Action: cd ~/labs/mobile-stack && vagrant up"
echo "------------------------------------------------"
