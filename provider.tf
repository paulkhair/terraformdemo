terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }     
  }
  
  backend "azurerm" {
        resource_group_name  = "tfstaterg0001"
        storage_account_name = "tfstatesta0001"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
        subscription_id = "*********"
        tenant_id       = "*********"
    }
}
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "*********"
  tenant_id       = "*********"
}