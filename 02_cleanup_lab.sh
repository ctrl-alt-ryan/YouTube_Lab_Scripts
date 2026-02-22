#!/bin/bash

echo "------------------------------------------------"
echo "Initiating Mobile-Stack Sanitization..."
echo "------------------------------------------------"

# 1. Enter the lab directory
if [ -d "~/labs/mobile-stack" ]; then
    cd ~/labs/mobile-stack
fi

# 2. Destroy the Vagrant environment
echo "[*] Tearing down virtual machines and volumes..."
vagrant destroy -f

# 3. Clean up the Libvirt storage pool (System Level)
echo "[*] Pruning stale system-level volumes..."
# This ensures no 'ghost' images are left in /var/lib/libvirt/images
sudo virsh -c qemu:///system vol-delete --pool default mobile-stack_rocky-server.img 2>/dev/null

# 4. Final Cleanup
echo "[*] Removing Lab directory..."
rm -rf ~/labs/mobile-stack

echo "------------------------------------------------"
echo "Environment Sanitized. Host is Pristine."
echo "------------------------------------------------"
