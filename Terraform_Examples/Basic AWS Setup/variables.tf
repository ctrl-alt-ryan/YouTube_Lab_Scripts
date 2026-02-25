# --- Region & Naming ---
variable "aws_region" {
  type    = string
  default = "us-east-1" # Northern Virginia (The AWS equivalent of East US)
}

variable "project_name" {
  type    = string
  default = "Ctrl-Alt-Ryan-3TierLab"
}

# --- Networking ---
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "app_subnet_name" {
  type    = string
  default = "app-subnet"
}

variable "db_subnet_name" {
  type    = string
  default = "db-subnet"
}

# --- Compute ---
variable "instance_type" {
  type    = string
  default = "t3.micro" # Free Tier Eligible
}

variable "admin_username" {
  type    = string
  default = "ubuntu" # AWS Ubuntu AMIs use 'ubuntu' by default
}

# --- Security & Ports ---
variable "web_ports" {
  type    = list(number)
  default = [80, 443]
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
