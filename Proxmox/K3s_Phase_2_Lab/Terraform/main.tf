resource "proxmox_vm_qemu" "k3s_nodes" {
  for_each    = var.nodes
  name        = each.key
  target_node = "proxmox-node-name" # Your physical Proxmox host name
  vmid        = each.value.vmid
  
  # Clone from the template you made in Phase 1
  clone       = "ubuntu-2404-template"
  full_clone  = true
  
  # Basic Specs
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  boot        = "c"
  bootdisk    = "scsi0"

  disk {
    size            = "20G"
    type            = "scsi"
    storage         = "local-lvm" # Or your specific storage name
    discard         = "on"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init Settings (Injects the IPs from your image!)
  ipconfig0 = "ip=${each.value.ip},gw=${each.value.gw}"
  
  # Use the SSH key from your laptop for Ansible access
  sshkeys = <<EOF
  ssh-rsa AAAAB3Nza...your-public-key...user@laptop
  EOF
}
