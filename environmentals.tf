/* SECTION DISABLED FOR DEMO, NO EXPRESS ROUTE AVAILABILITY

variable "MAC_UE_TENANT_ERC_AUTH_KEY"{
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_ERC_AUTH_KEY" 
}

SECTION DISABLED FOR DEMO, NO EXPRESS ROUTE AVAILABILITY */

// YOU SHOULD NOT BE MAKING CHANGES TO THIS SECTION OFTEN.
// TENANT AND SERVICE PRINCIPAL AKA SERVICE ACCOUNT SECTION:
variable "MAC_UE_TENANT_ARM_client_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_ARM_client_id"
}

variable "MAC_UE_TENANT_ARM_client_secret" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_ARM_client_secret"
}

variable "MAC_UE_TENANT_ARM_tenant_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_ARM_tenant_id"
}

// YOU SHOULD BE COMPLETING PULL REQUESTS FOR THIS SECTION OFTEN.
// INDIVIDUAL ALIAS SUBSCRIPTION SECTION:
variable "MAC_UE_TENANT_HUB_PROD_SUB_subscription_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_HUB_PROD_SUB_subscription_id"
}

variable "MAC_UE_TENANT_MY_APP_PROD_SUB_subscription_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_MY_APP_PROD_SUB_subscription_id"
}

variable "MAC_UE_TENANT_MY_APP_TEST_SUB_subscription_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_MY_APP_TEST_SUB_subscription_id"
}

variable "MAC_UE_TENANT_MY_APP_DEV_SUB_subscription_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_MY_APP_DEV_SUB_subscription_id"
}

variable "MAC_UE_TENANT_MY_APP_DEV_SUB_tenant_id" {
  type        = string
  description = "MAPS TO ENVIRONMENTAL VARIABLE TF_VAR_MAC_UE_TENANT_MY_APP_DEV_SUB_tenant_id"
}
