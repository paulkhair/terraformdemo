terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
  # No backend block here means it uses the "local" backend
}

provider "azurerm" {
  features {}
  # Credentials will be handled by Environment Variables in GitHub Actions
}