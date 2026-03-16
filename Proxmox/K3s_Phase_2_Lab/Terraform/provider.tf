terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07" # Use the latest stable/rc version
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://10.3.140.204:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "Xpn4412!!" # Not a token
  pm_tls_insecure = true
  pm_log_enable   = true
  pm_debug            = true
  pm_parallel         = 1
  pm_timeout          = 600
}
