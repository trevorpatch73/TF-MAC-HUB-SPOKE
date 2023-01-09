// Terraform has cyclical issue with compliation.
// Thus providers are masked behind an alias.
// Each subscription gets its own alias provider.
provider "azurerm" {
  features {}

  // UPDATE THIS VARIABLE TO MAKE THE SUBSCRIPTION BEING BUILT
  subscription_id = var.MAC_UE_TENANT_MY_APP_DEV_SUB_subscription_id

  client_id     = var.MAC_UE_TENANT_ARM_client_id
  client_secret = var.MAC_UE_TENANT_ARM_client_secret
  tenant_id     = var.MAC_UE_TENANT_ARM_tenant_id

  // UPDATE THIS VARIABLE TO MAKE THE SUBSCRIPTION BEING BUILT
  alias = "MAC_UE_TENANT_MY_APP_DEV_SUB"
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// Nothing more should be done on a BAU basis
resource "azurerm_resource_group" "MAC_UE_TENANT_MY_APP_DEV_RG" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name     = "MAC-UE-TENANT-MY-APP-DEV-RG"
  location = "East US"

  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Development"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Organizer"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// Nothing more should be done on a BAU basis
resource "azurerm_virtual_network" "MAC_UE_TENANT_MY_APP_DEV_VNET" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name                = "MAC-UE-TENANT-MY-APP-DEV-VNET"
  location            = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM. 
  address_space = ["30.3.0.0/24"]

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Development"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Recommended to copy/paste and manually update the elements of these resources
// Recommend provisioning enough space to put at minimum a /26 in each AZ
// This should not be a section touched often after standup
resource "azurerm_subnet" "MAC_UE_TENANT_MY_APP_DEV_SUBNET" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name                 = "MAC-UE-TENANT-MY-APP-DEV-SUBNET"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM.   
  address_prefixes = ["30.3.0.0/24"]
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// This should not be a section touched often after standup
resource "azurerm_route_table" "MAC_UE_TENANT_MY_APP_DEV_RT" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name                = "MAC-UE-TENANT-MY-APP-DEV-RT"
  location            = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name

  route {
    name                   = "default_route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "MAC_UE_TENANT_MY_APP_DEV_RT_ASSOC" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  subnet_id      = azurerm_subnet.MAC_UE_TENANT_MY_APP_DEV_SUBNET.id
  route_table_id = azurerm_route_table.MAC_UE_TENANT_MY_APP_DEV_RT.id
}

resource "azurerm_virtual_network_peering" "MAC_UE_TENANT_MY_APP_DEV_PEER" {
  provider   = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB
  depends_on = [azurerm_virtual_network_gateway.MAC_UE_TENANT_HUB_EXPRESS_ROUTE_VIRTUAL_NETWORK_GATEWAY]

  name                      = "MAC-UE-TENANT-MY-APP-DEV-PEER"
  resource_group_name       = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  virtual_network_name      = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET.name
  remote_virtual_network_id = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

