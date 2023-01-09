// The following section is for the initialization of Terraform
// and completing all the required dependencies

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }

  // It is recommended to use a Storage Account Access Key
  // Review the Read.ME on generating a key or MS Site
  // The Access Key Value must be storaged in environmental
  // variables as "ARM_ACCESS_KEY". Terraform will pick
  // up this mapping without any declarative action.  
  backend "azurerm" {
    // Review the READ.ME to establish a RG manually
    // It is recommended to have a storage account per TF Runtime
    // It is recommended to name the workspace comply to the schema
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate31177"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

// The following provider block is required to initialize Terraform
provider "azurerm" {
  features {}

  client_id     = var.MAC_UE_TENANT_ARM_client_id
  client_secret = var.MAC_UE_TENANT_ARM_client_secret
  tenant_id     = var.MAC_UE_TENANT_ARM_tenant_id
}