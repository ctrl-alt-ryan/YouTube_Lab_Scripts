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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsX73iHuxvjUPar0kq8ma2Yc85/NDSwyXj72S/D748RsuEe1O42Mf0YKpg0dZffsxYmf7Ts3SPL0Q29rvlBT1PafGGNaToc2Rth3xIaOsmNJPI0eMlGPfMa7w1tUGBIZCUK1H2tu0uhgkDKcgAhSLVcKhMRQuYeichnWzBjOoOuam7pCCn2iG9XhCQScyZopCaHCNZGA7tXGL6Ji6EzazqDhjFcLgsRqLXOUMiZ0upUBQDAdjXHsKmosTXVggDee5d+EbXv5k94x7t4Zr/qpwRsNkjHvBYVmRjlfl2bYWE7zn4Exb4In9SB6DVbZGsIradkhIqXsCfEbLUQCHx7VSVLK0wxIXhKjWfHk/dZ7FGx3Rkphqti9cbX5sgqXptqlfgBnqXJr2tCVkR3uAx9JiHxQkHrTbL5xBlMLbz1voRfZNDeE5ZdLx4WSgcjc1z9hk7Xwhyi+Oaq0hZXmHVyz/5/FWA5btJisEPPTa1hjTURcHvFQE5yVgsAk+QfThChLN+3ognRADcKHlg7hwf1fZ2IBG2lAOjgko6ATCe2/R+5WbYJSAINBk4pD+q+Otbkhy522vCKa0yfAnNXVoNourOy/QEbCQi7XTpYC3lYb+JUY9HEjwTlbFGocSSs1aFKLhfBynLxRGAkm7kI9gPxjyy17Jgy8P5QBBD/IG6SYZzJQ== ryan@RG-Fedora-S1
EOF
}
