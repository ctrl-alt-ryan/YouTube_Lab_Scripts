resource "proxmox_vm_qemu" "k3s_nodes" {
  for_each    = var.nodes
  name        = each.key
  target_node = "node4"
  vmid        = each.value.vmid

  clone       = "template-ubuntu-24" #Name of your Template
  full_clone  = true

  agent   = 1
  os_type = "l26"
  bios    = "seabios"

  cpu {
    cores   = 1
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory = 2048

  scsihw = "virtio-scsi-single"
  boot   = "order=scsi0;net0"

  disk {
    slot            = "scsi0"
    size            = "32G"
    type            = "disk"
    storage         = "local-lvm"
    iothread        = true
    discard         = true
  }

  disk {
    slot            = "ide2"
    type            = "cloudinit"
    storage         = "local-lvm"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  ciuser     = "xpsadmin"

  # Ensure CIDR is present. If your var.nodes doesn't have /24,
  # use: "ip=${each.value.ip}/24,gw=${each.value.gw}"
  ipconfig0  = "ip=${each.value.ip},gw=${each.value.gw}"

  sshkeys    = <<EOF
YOUR-SSH-KEYS
EOF
}
