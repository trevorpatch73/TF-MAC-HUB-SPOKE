// Terraform has cyclical issue with compliation.
// Thus providers are masked behind an alias.
// Each subscription gets its own alias provider.
provider "azurerm" {
  features {}

  // UPDATE THIS VARIABLE TO MAKE THE SUBSCRIPTION BEING BUILT
  subscription_id = var.MAC_UE_TENANT_HUB_PROD_SUB_subscription_id

  client_id     = var.MAC_UE_TENANT_ARM_client_id
  client_secret = var.MAC_UE_TENANT_ARM_client_secret
  tenant_id     = var.MAC_UE_TENANT_ARM_tenant_id

  // UPDATE THIS VARIABLE TO MAKE THE SUBSCRIPTION BEING BUILT
  alias = "MAC_UE_TENANT_HUB_PROD_SUB"
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// Nothing more should be done on a BAU basis
resource "azurerm_resource_group" "MAC_UE_TENANT_HUB_PROD_RG" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name     = "MAC-UE-TENANT-HUB-PROD-RG"
  location = "East US"

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Organizer"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// THIS IS NOT A SECTION TOUCHED OFTEN AFTER STANDUP
resource "azurerm_virtual_network" "MAC_UE_TENANT_HUB_PROD_VNET" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-VNET"
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM.
  address_space = ["30.0.0.0/16"]

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>_<spoke-network>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Recommended to copy/paste and manually update the elements of these resources
// THIS IS A SECTION WORKED OFTEN AS PART OF BAU IN ADDING NEW BUILDS
resource "azurerm_virtual_network_peering" "MAC_UE_TENANT_HUB_PROD_PEER_30_1_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and replace should update everything prior to PEER.
  // You will need to update the trailing network dot dec value
  name                 = "MAC-UE-TENANT-HUB-PROD-PEER-30-1-0-0"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // Be sure to update the resource below for the spoke vnent actually being built.
  remote_virtual_network_id = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_PROD_VNET.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true

  // Be sure to update the resource below for the spoke vnent actually being built.
  depends_on = [
    azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET,
    azurerm_virtual_network.MAC_UE_TENANT_MY_APP_PROD_VNET
  ]
}

resource "azurerm_virtual_network_peering" "MAC_UE_TENANT_HUB_PROD_PEER_30_2_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and replace should update everything prior to PEER.
  // You will need to update the trailing network dot dec value
  name                 = "MAC-UE-TENANT-HUB-PROD-PEER-30-2-0-0"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // Be sure to update the resource below for the spoke vnent actually being built.  
  remote_virtual_network_id = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_TEST_VNET.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true

  // Be sure to update the resource below for the spoke vnent actually being built.
  depends_on = [
    azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET,
    azurerm_virtual_network.MAC_UE_TENANT_MY_APP_TEST_VNET
  ]
}

resource "azurerm_virtual_network_peering" "MAC_UE_TENANT_HUB_PROD_PEER_30_3_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and replace should update everything prior to PEER.
  // You will need to update the trailing network dot dec value
  name                 = "MAC-UE-TENANT-HUB-PROD-PEER-30-3-0-0"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // Be sure to update the resource below for the spoke vnent actually being built.    
  remote_virtual_network_id = azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true

  // Be sure to update the resource below for the spoke vnent actually being built.  
  depends_on = [
    azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET,
    azurerm_virtual_network.MAC_UE_TENANT_MY_APP_DEV_VNET
  ]
}

// GATEWAY SUBNET FOR THE EXPRESS ROUTE AND EXPRESS ROUTE VIRTUAL NETWORK GATEWAY
// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Recommended to copy/paste and manually update the elements of these resources
resource "azurerm_subnet" "MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // NAME IS NON-COMPLIANT DUE TO OEM REQUIREMENTS
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM.  
  address_prefixes = ["30.0.0.0/24"]
}

/* SECTION DISABLED FOR DEMO, NO EXPRESS ROUTE AVAILABILITY

resource "azurerm_express_route_circuit" "MAC_UE_TENANT_HUB_PROD_ERC" {
  name                  = "MAC-UE-TENANT-HUB-PROD-ERC"
  resource_group_name   = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  location              = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  service_provider_name = "Equinix"
  peering_location      = "Washington DC"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub Edge"
  }
  }
}

resource "azurerm_express_route_circuit_peering" "MAC_UE_TENANT_EXPRESS_ROUTE_PEERING" {
  peering_type                  = "AzurePrivatePeering"
  resource_group_name           = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  express_route_circuit_name    = azurerm_express_route_circuit.MAC_UE_TENANT_HUB_PROD_ERC.name

  // GET THE FOLLOWING REQUIREMENTS FROM THE NETWORK TEAM
  peer_asn                      = 100
  primary_peer_address_prefix   = "123.0.0.0/30"
  secondary_peer_address_prefix = "123.0.0.4/30"
  ipv4_enabled                  = true
  vlan_id                       = 300
}

resource azurerm_virtual_network_gateway_connection "MAC_UE_TENANT_ER_VNG_CON" {
    name                = "MAC_UE_TENANT_ER_VNG_CON"
    location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
    resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name

    type                            = "ExpressRoute"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.MAC_UE_TENANT_HUB_EXPRESS_ROUTE_VIRTUAL_NETWORK_GATEWAY.id
    express_route_circuit_id        = azurerm_express_route_circuit.MAC_UE_TENANT_HUB_PROD_ERC.id
    authorization_key               = var.MAC_UE_TENANT_ERC_AUTH_KEY
}

SECTION DISABLED FOR DEMO, NO EXPRESS ROUTE AVAILABILITY */

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
resource "azurerm_public_ip" "MAC_UE_TENANT_HUB_PROD_ER_VNG_PIP" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-ER-VNG-PIP"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  allocation_method   = "Dynamic"

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub Edge"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
resource "azurerm_virtual_network_gateway" "MAC_UE_TENANT_HUB_EXPRESS_ROUTE_VIRTUAL_NETWORK_GATEWAY" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-ER-VNG"
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  // CHANGE THESE TO THE AZ HA REDUNDANT SKU NOT AVAILABLE IN DEMO
  sku = "Standard"

  type     = "ExpressRoute"
  vpn_type = "PolicyBased"

  ip_configuration {
    name                          = "MAC-UE-TENANT-HUB-ER-VNG-IP-CONFIGURATION"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET.id
    public_ip_address_id          = azurerm_public_ip.MAC_UE_TENANT_HUB_PROD_ER_VNG_PIP.id
  }

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub Edge"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
resource "azurerm_route_table" "MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-GATEWAY-SUBNET-RT"
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub"
  }
}

// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>_<spoke-network>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Recommended to copy/paste and manually update the elements of these resources
// THIS IS A SECTION WORKED OFTEN AS PART OF BAU IN ADDING NEW BUILDS
resource "azurerm_route" "MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT_30_1_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and Replace on the schema should up too RT, but manually update the network
  name                = "MAC-UE-TENANT-HUB-PROD-GATEWAY-SUBNET-RT-30-1-0-0"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  route_table_name    = azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT.name
  // AZURE REQUIRES AN ENTRY FOR EACH REMOTE SUBNET IN SPOKE VNET, 
  // NOT THE MACRO VNET CIDR; SUMMARY ROUTING DOES NOT WORK
  address_prefix         = "30.1.0.0/24"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL.ip_configuration[0].private_ip_address
  depends_on = [
    azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG,
    azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT
  ]
}

resource "azurerm_route" "MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT_30_2_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and Replace on the schema should up too RT, but manually update the network
  name                = "MAC-UE-TENANT-HUB-PROD-GATEWAY-SUBNET-RT-30-2-0-0"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  route_table_name    = azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT.name
  // AZURE REQUIRES AN ENTRY FOR EACH REMOTE SUBNET IN SPOKE VNET, 
  // NOT THE MACRO VNET CIDR; SUMMARY ROUTING DOES NOT WORK
  address_prefix         = "30.2.0.0/24"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL.ip_configuration[0].private_ip_address
  depends_on = [
    azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG,
    azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT
  ]
}

resource "azurerm_route" "MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT_30_3_0_0" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // Find and Replace on the schema should up too RT, but manually update the network
  name                = "MAC-UE-TENANT-HUB-PROD-GATEWAY-SUBNET-RT-30-3-0-0"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  route_table_name    = azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT.name
  // AZURE REQUIRES AN ENTRY FOR EACH REMOTE SUBNET IN SPOKE VNET, 
  // NOT THE MACRO VNET CIDR; SUMMARY ROUTING DOES NOT WORK
  address_prefix         = "30.3.0.0/24"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL.ip_configuration[0].private_ip_address
  depends_on = [
    azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG,
    azurerm_route_table.MAC_UE_TENANT_HUB_PROD_GATEWAY_SUBNET_RT
  ]
}

// AZURE FIREWALL SECTION
// The schema used is:
// <cloud>_<region>_<tenant>_<application>_<environment>_<object>
// where "legacy" should be used for <application> in on-prem data center mirrors
// Find and Replace should be used to update schema on new build
// THIS IS NOT A SECTION TOUCHED OFTEN AFTER STANDUP
resource "azurerm_subnet" "MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_SUBNET" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // NAME IS NON-COMPLIANT DUE TO OEM REQUIREMENTS
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM.
  address_prefixes = ["30.0.1.0/24"]
}

resource "azurerm_subnet" "MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_MANAGEMENT_SUBNET" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  // NAME IS NON-COMPLIANT DUE TO OEM REQUIREMENTS
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  virtual_network_name = azurerm_virtual_network.MAC_UE_TENANT_HUB_PROD_VNET.name
  // This value needs to be static assigned. Check ADD/ADR and IPAM.
  address_prefixes = ["30.0.2.0/24"]
}

resource "azurerm_public_ip" "MAC_UE_TENANT_HUB_PROD_AZURE_FW_PIP" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-AZURE-FW-PIP"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  allocation_method   = "Static"
  sku                 = "Standard"

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub Edge"
  }
}

resource "azurerm_public_ip" "MAC_UE_TENANT_HUB_PROD_AZURE_FW_MGMT_PIP" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-AZURE-FW-MGMT-PIP"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  allocation_method   = "Static"
  sku                 = "Standard"

  // Find and Replace should be used to update appropriate tags
  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Network Hub Edge"
  }
}

resource "azurerm_firewall_policy" "MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_POL" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-AZURE-FIREWALL-POLICY"
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
}

resource "azurerm_firewall" "MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name                = "MAC-UE-TENANT-HUB-PROD-AZURE-FIREWALL"
  location            = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.location
  resource_group_name = azurerm_resource_group.MAC_UE_TENANT_HUB_PROD_RG.name
  // CHANGE THESE TO THE AZ HA REDUNDANT SKUs & TIERs
  sku_name           = "AZFW_VNet"
  sku_tier           = "Standard"
  firewall_policy_id = azurerm_firewall_policy.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_POL.id

  ip_configuration {
    name                 = "AzureFirewallSubnet_IP_Configuration"
    subnet_id            = azurerm_subnet.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_SUBNET.id
    public_ip_address_id = azurerm_public_ip.MAC_UE_TENANT_HUB_PROD_AZURE_FW_PIP.id
  }

  management_ip_configuration {
    name                 = "AzureFirewallManagementSubnet_IP_Configuration"
    subnet_id            = azurerm_subnet.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_MANAGEMENT_SUBNET.id
    public_ip_address_id = azurerm_public_ip.MAC_UE_TENANT_HUB_PROD_AZURE_FW_MGMT_PIP.id
  }

  tags = {
    Application        = "Infrastructure"
    DataClassification = "Classified"
    MissionCriticality = "Mission-Critical"
    ProductOwner       = "Cloud Operations"
    OpsCommitment      = "Baseline"
    OpsTeam            = "Cloud Operations"
    Environment        = "Production"
    Location           = "MAC-US-EAST"
    CostCenter         = "XXXX-XXXX-XXXX-XXXX"
    Role               = "Macro-Segmentation"
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_POL_RCG" {
  provider = azurerm.MAC_UE_TENANT_HUB_PROD_SUB

  name               = "MAC-UE-TENANT-HUB-PROD-AZURE-FIREWALL-POL-RCG"
  firewall_policy_id = azurerm_firewall_policy.MAC_UE_TENANT_HUB_PROD_AZURE_FIREWALL_POL.id
  priority           = 500

  // THIS IS A SECTION THAT YOU WILL WORK IN OFTEN
  network_rule_collection {
    name     = "CORE_SERVICES"
    priority = 500
    action   = "Allow"

    rule {
      name                  = "RDP"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["3389"]
    }

    rule {
      name                  = "PING"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

  }
}

