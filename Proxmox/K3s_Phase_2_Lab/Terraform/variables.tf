variable "nodes" {
  type = map(object({
    vmid = number
    ip   = string
    gw   = string
  }))
  default = {
    "k3s-ctlr-01"   = { vmid = 301, ip = "10.3.160.101/16", gw = "10.3.0.1" }
    "k3s-ctlr-02"   = { vmid = 302, ip = "10.3.160.102/16", gw = "10.3.0.1" }
    "k3s-ctlr-03"   = { vmid = 303, ip = "10.3.160.103/16", gw = "10.3.0.1" }
    "k3s-worker-01" = { vmid = 311, ip = "10.3.160.104/16", gw = "10.3.0.1" }
    "k3s-worker-02" = { vmid = 312, ip = "10.3.160.105/16", gw = "10.3.0.1" }
  }
}
