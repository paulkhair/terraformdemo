## Azure Infrastructure Automation with Terraform & GitHub Actions
This repository demonstrates a production-ready CI/CD pipeline for managing Microsoft Azure infrastructure. It aligns with modern engineering standards by utilizing Infrastructure as Code (IaC), automated workflows, and secure remote state management.

### 🚀 Project Overview
The goal of this project is to automate the deployment of Azure resources while ensuring a "Single Source of Truth." By integrating GitHub Actions with an Azure Blob Storage backend, we achieve:
	• Automation: 100% automated deployment cycles, mirroring my experience reducing deployment times by 80%.
	• Consistency: Elimination of configuration drift across environments.
	• Security: State files are encrypted and stored externally to prevent sensitive data leaks.

### 🛠 Prerequisites
	1. Azure Subscription: Access to create Resource Groups and Storage Accounts.
	2. GitHub Repository: To host the code and Secrets.
	3. Terraform CLI: Installed locally for initial configuration.

### 📝 Step-by-Step Implementation
1. Provision the Remote Backend
To ensure high availability and state locking—critical for mission-critical systems—we store the tfstate in Azure:
Bash

# Create the storage for Terraform State
az group create --name tfstate-rg --location westeurope
az storage account create --name paultfstate001 --resource-group tfstate-rg --sku Standard_LRS
az storage container create --name tfstate --account-name paultfstate001
2. Configure the Provider & Backend
Update the provider.tf to point to the Azure container. This ensures that the GitHub Runner always has access to the latest infrastructure state.
Terraform

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "paultfstate001"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
3. Secure GitHub Secrets
To automate deployments safely, the following credentials must be stored in GitHub Settings > Secrets > Actions:
	• AZURE_CLIENT_ID
	• AZURE_CLIENT_SECRET
	• AZURE_SUBSCRIPTION_ID
	• AZURE_TENANT_ID
4. The CI/CD Workflow
The .github/workflows/terraform.yml file automates the entire lifecycle.
	• On Pull Request: Executes terraform plan to validate changes before merging.
	• On Push to Main: Executes terraform apply to update the productive environment.

### 💡 Why this architecture?
For a Virtual Power Plant provider like Next Kraftwerke, infrastructure reliability is non-negotiable.
	• State Locking: Using the azurerm backend prevents concurrent runs from corrupting the infrastructure state.
	• Audit Trail: Every change is documented in GitHub Actions logs, supporting regulatory requirements (like KRITIS).
	• Scalability: This workflow allows the team to scale infrastructure rapidly as new energy assets are added to the plant.

### 👨‍💻 About the Author
Paul Faltas Azure Cloud Architect | 12 Years Experience 
	• Expert in Cloud Architecture, Governance, and Automation.
	• Proven track record at Robert Bosch GmbH and Atos.
	• Currently advancing German language skills (A2/B1) for better local integration.
