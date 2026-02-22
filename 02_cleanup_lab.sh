#!/bin/bash

# Navigate to the lab directory
cd ~/labs/mobile-stack

# Tear down the VMs and remove the Libvirt volumes
echo "Tearing down the lab..."
vagrant destroy -f

# Optional: Remove the directory entirely
# cd .. && rm -rf mobile-stack

echo "Mission complete. The area has been policed."
