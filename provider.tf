terraform {
  # 1. This block handles the remote state and execution in Terraform Cloud
  cloud {
    organization = "tfpauldemo" 

    workspaces {
      name = "tfdemo" 
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # Note: When using GitHub Actions, it is safer to pass these 
  # via Environment Variables rather than hardcoding them here.
  #subscription_id = "*********"
  #tenant_id       = "*********"
}