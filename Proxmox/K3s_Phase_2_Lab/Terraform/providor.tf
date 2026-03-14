terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4" # Use the latest stable/rc version
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://[PROXMOX-IP]:8006/api2/json"
  pm_api_token_id = "terraform-prov@pve!token-name" # The ID you created
  pm_api_token_secret = "your-api-secret-here"
  pm_tls_insecure = true # Set to false if you have valid SSL
}
