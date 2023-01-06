// MACRO-LEVEL-OBJECTS
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

resource "azurerm_virtual_network" "MAC_UE_TENANT_MY_APP_DEV_VNET" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name                = "MAC-UE-TENANT-MY-APP-DEV-VNET"
  location            = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  address_space       = ["30.3.0.0/24"]

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

resource "azurerm_subnet" "MAC_UE_TENANT_MY_APP_DEV_SUBNET" {
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB

  name                 = "MAC-UE-TENANT-MY-APP-DEV-SUBNET"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET.name
  address_prefixes     = ["30.3.0.0/24"]
}

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
  provider = azurerm.MAC_UE_TENANT_MY_APP_DEV_SUB
  depends_on = [azurerm_virtual_network_gateway.MAC_UE_TENANT_HUB_EXPRESS_ROUTE_VIRTUAL_NETWORK_GATEWAY]

  name                      = "MAC-UE-TENANT-MY-APP-DEV-PEER"
  resource_group_name       = azurerm_resource_group.MAC_UE_TENANT_MY_APP_DEV_RG.name
  virtual_network_name      = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET.name
  remote_virtual_network_id = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

