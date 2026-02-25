terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Change from 3.0 to 4.0
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
