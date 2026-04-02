# Resource Group & Location
variable "rg_name" {
  type    = string
  default = "Ryan-Lab-RG"
}

variable "location" {
  type    = string
  default = "East US"
}

# Networking Names & Address Spaces
variable "vnet_name" {
  type    = string
  default = "lab-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "app_subnet_name" {
  type    = string
  default = "app-subnet"
}

variable "app_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "db_subnet_name" {
  type    = string
  default = "db-subnet"
}

variable "db_subnet_prefix" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

# SKUs and Compute
variable "lb_sku" {
  type    = string
  default = "Standard"
}

variable "pip_sku" {
  type    = string
  default = "Standard"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "ryan"
}

variable "web_ports" {
  type    = list(string)
  default = ["80", "443"]
}

variable "db_port" {
  type    = string
  default = "3306" # Standard for MySQL/MariaDB
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
