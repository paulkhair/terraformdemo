# Cloud Infrastructure on Azure with [Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code)

Learn how to use pre-defined Terraform modules, you can customize (add module, remove module) and use this code based on your needs.

This service in created by Cloud Engineering team, if you need to know more about the team please follow this [link](https://pace-project.atlassian.net/wiki/spaces/SOCOTEC/pages/187992613/Cloud+Engineering).

## File Structure 

- main.tf

In the main.tf you can create resources, like virtual machine, app services and databases, as well as Data resources which is the way where you can reference objects that are not created in your code. For example, if you had a central Key Vault, you could use a data Resource to lookup a Key Vault Secret.

- provider.tf

In the Provider.tf file you will find the configurations for [Azure Cloud Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) and the backend configuration to store the [TFstate](https://developer.hashicorp.com/terraform/language/state) database file in Azure Blob Storage.

- [Modules](https://developer.hashicorp.com/terraform/language/modules) 

Modules are containers of multiple resources that are used together, its the main way to package and reuse resource configurations with Terraform.

* Note:
In the Modules Folder you will find a module for each Service/Resource you want to create on Azure, and each module contains the same structure additionaly has output.tf, and variable.tf

- [output.tf](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-outputs)

Output values allow you to organize data to be easily queried and displayed to the Terraform user.
if you got multiple workspaces, or if you are using modules, you could create outputs. Usually, we use it for the multi-deployment code that consume outputs from other workspaces.

- [variables.tf](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-variables)

Variables serve as parameters for a Terraform module, so users can customize behavior without editing the source. 

## Get started locally

All terraform commands can be run via bash scripts, or Powershell script. So you need to [install Azure Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) and [Terraform Client](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash) on your local machine.

**A- [Authenticate](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) Azure CLI**
> `az login`

It will redirect you to the browser to authenticate and gets a message that "You have logged into Microsoft Azure!"

**B- Create a Storage Account and a Container to store the TFstate file**
Please follow this [link](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli) in order to Store Terraform state in Azure Storage.

Or you can run the below command to execute the bash script in the code "create-azure-storage-account.sh"
> `./ create-azure-storage-account.sh`

**C- Configure the Provider and Backend for TFState File**


1- Clone this repo in your local machine.
> `git clone https://github.com/PACE-INT/Terraform.CloudEngineering`

2- Go to the provider.tf file and edit the values of your subscription and tenant ID in the backend "azurerm". 
    
        backend "azurerm" {
            resource_group_name  = "tfstaterg0001"
            storage_account_name = "tfstatesta0001"
            container_name       = "tfstate"
            key                  = "terraform.tfstate"
            subscription_id = "*********"
            tenant_id       = "*********"
        }

And do the same in the provider "azurerm" block (put your subscription and Tenant ID that you need to create the resources inside)

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


3- Now you are successfully configured the Backend to Store the TFstate and the Provider, so you can start to create the resources.

**D- Create the Resources**

1- Go the main.tf file and edit the locals as below (assetname, environment, and location) to have a format for any resource will be created in the future, so you can use resource_name as an abbreviation naming for any resource:
        
        locals {
            assetname   = "projectname"
            environment = "dev"
            location    = "westeurope"

            resource_name = format("%s-%s-%s", local.assetname, local.environment, local.location)
        }

A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

2- Here is an example to start our environment
        
        resource "azurerm_resource_group" "resourcegroup" {
        name     = "${local.resource_name}-rg-main"
        location = local.location
        }

- Here you will create the first resource group for your work, the resource group name will be as the local format your created above.  format ("%s-%s-%s", local.assetname, local.environment, local.location), so it will be "projectname.dev.westeurop-rg-main".

- You can create another resource group by using the same format, you just need to change the word after the brakets as below.
        name     = "${local.resource_name}-rg-****"

3- The second step is to create the resources, by using modules inside the folder called 'modules', we already created modules for the below services:
 - Azure Key Vault
 - Azure MSSQL Database
 - Azure Service Plan
 - Azure Storage Account

Each module holds all the dependencies needed. For example, you will find that the module for app service plan holds Linux web app service.

If you need to create any resource, you must create a module for it as we did for the above resources.

4- To create a resource you just need to call the module as below:

        module "azurerm_storage_accounts" {
            source = "./modules/azurerm_storage_account"

            resource_group_name     = azurerm_resource_group.resourcegroup.name
            resource_group_location = azurerm_resource_group.resourcegroup.location
            assetname               = local.assetname
            environment             = local.environment
            instance_count          = 1
        }

So you are calling the module by the source name of the module, which it "./modules/azurerm_storage_account" in our example.



5- [Initialize](https://developer.hashicorp.com/terraform/tutorials/cli/init?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS) Terraform configuration (prepares the working directory so Terraform can run the configuration)
> `terraform init`

6- [Create](https://developer.hashicorp.com/terraform/tutorials/cli/plan) a Terraform Plan (enables you to preview any changes before you apply them)
> `terraform plan`

7- [Apply](https://developer.hashicorp.com/terraform/tutorials/cli/apply) a Terraform Configuration (makes the changes defined by your Terraform configuration to create, update, or destroy resources)
> `terraform apply`
