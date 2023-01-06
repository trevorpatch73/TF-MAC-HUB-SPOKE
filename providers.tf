terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
  backend "azurerm" {
    // SEE READ.ME, YOU NEED TO UPDATE STORAGE ACCOUNT NAME
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate31177"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.MAC_UE_TENANT_HUB_PROD_SUB_subscription_id
  client_id       = var.MAC_UE_TENANT_HUB_PROD_SUB_client_id
  client_secret   = var.MAC_UE_TENANT_HUB_PROD_SUB_client_secret
  tenant_id       = var.MAC_UE_TENANT_HUB_PROD_SUB_tenant_id

  alias = "MAC_UE_TENANT_HUB_PROD_SUB"
}

provider "azurerm" {
  features {}

  subscription_id = var.MAC_UE_TENANT_MY_APP_PROD_SUB_subscription_id
  client_id       = var.MAC_UE_TENANT_MY_APP_PROD_SUB_client_id
  client_secret   = var.MAC_UE_TENANT_MY_APP_PROD_SUB_client_secret
  tenant_id       = var.MAC_UE_TENANT_MY_APP_PROD_SUB_tenant_id

  alias = "MAC_UE_TENANT_MY_APP_PROD_SUB"
}

provider "azurerm" {
  features {}

  subscription_id = var.MAC_UE_TENANT_MY_APP_TEST_SUB_subscription_id
  client_id       = var.MAC_UE_TENANT_MY_APP_TEST_SUB_client_id
  client_secret   = var.MAC_UE_TENANT_MY_APP_TEST_SUB_client_secret
  tenant_id       = var.MAC_UE_TENANT_MY_APP_TEST_SUB_tenant_id

  alias = "MAC_UE_TENANT_MY_APP_TEST_SUB"
}

provider "azurerm" {
  features {}

  subscription_id = var.MAC_UE_TENANT_MY_APP_DEV_SUB_subscription_id
  client_id       = var.MAC_UE_TENANT_MY_APP_DEV_SUB_client_id
  client_secret   = var.MAC_UE_TENANT_MY_APP_DEV_SUB_client_secret
  tenant_id       = var.MAC_UE_TENANT_MY_APP_DEV_SUB_tenant_id

  alias = "MAC_UE_TENANT_MY_APP_DEV_SUB"
}