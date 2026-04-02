resource "proxmox_vm_qemu" "k8s_nodes" {
  for_each    = var.k8s_nodes
  name        = each.key
  target_node = "node4"
  vmid        = each.value.vmid

  clone       = "template-ubuntu-24"
  full_clone  = true

  agent   = 1
  os_type = "l26"
  bios    = "seabios"

  # UPGRADE: 2 Cores / 4GB RAM (K8s minimums)
  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory = 4096

  scsihw = "virtio-scsi-single"
  boot   = "order=scsi0;net0"

  # OS DISK: Uses the 'size' from your variables.tf
  disk {
    slot     = "scsi0"
    size     = each.value.size
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
    discard  = true
  }

  # DATA DISK: Adding the 50GB VirtIO drive for Longhorn
  dynamic "disk" {
    for_each = length(regexall("worker", each.key)) > 0 ? [1] : []
    content {
      slot     = "virtio0"
      size     = "50G"
      type     = "disk"
      storage  = "local-lvm"
      iothread = true
      discard  = true
    }
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  ciuser     = "xpsadmin"
  ipconfig0  = "ip=${each.value.ip},gw=${each.value.gw}"
  sshkeys    = var.ssh_public_key
}
