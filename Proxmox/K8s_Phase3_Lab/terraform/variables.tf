variable "k8s_nodes" {
  type = map(object({
    vmid = number
    ip   = string
    gw   = string
    size = string # Different sizes for Controller vs Worker
  }))
  default = {
    "k8s-controller-01" = { vmid = 301, ip = "10.3.160.101/16", gw = "10.3.0.1", size = "32G" }
    "k8s-worker-01"     = { vmid = 311, ip = "10.3.160.104/16", gw = "10.3.0.1", size = "32G" }
    "k8s-worker-02"     = { vmid = 312, ip = "10.3.160.105/16", gw = "10.3.0.1", size = "32G" }
  }
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsX73iHuxvjUPar0kq8ma2Yc85/NDSwyXj72S/D748RsuEe1O42Mf0YKpg0dZffsxYmf7Ts3SPL0Q29rvlBT1PafGGNaToc2Rth3xIaOsmNJPI0eMlGPfMa7w1tUGBIZCUK1H2tu0uhgkDKcgAhSLVcKhMRQuYeichnWzBjOoOuam7pCCn2iG9XhCQScyZopCaHCNZGA7tXGL6Ji6EzazqDhjFcLgsRqLXOUMiZ0upUBQDAdjXHsKmosTXVggDee5d+EbXv5k94x7t4Zr/qpwRsNkjHvBYVmRjlfl2bYWE7zn4Exb4In9SB6DVbZGsIradkhIqXsCfEbLUQCHx7VSVLK0wxIXhKjWfHk/dZ7FGx3Rkphqti9cbX5sgqXptqlfgBnqXJr2tCVkR3uAx9JiHxQkHrTbL5xBlMLbz1voRfZNDeE5ZdLx4WSgcjc1z9hk7Xwhyi+Oaq0hZXmHVyz/5/FWA5btJisEPPTa1hjTURcHvFQE5yVgsAk+QfThChLN+3ognRADcKHlg7hwf1fZ2IBG2lAOjgko6ATCe2/R+5WbYJSAINBk4pD+q+Otbkhy522vCKa0yfAnNXVoNourOy/QEbCQi7XTpYC3lYb+JUY9HEjwTlbFGocSSs1aFKLhfBynLxRGAkm7kI9gPxjyy17Jgy8P5QBBD/IG6SYZzJQ== ryan@RG-Fedora-S1"
}
