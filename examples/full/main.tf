resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

module "vnet" {
  source                  = "../../"
  name                    = "vnet-example"
  resource_group_name     = azurerm_resource_group.vnetrg.name
  address_space           = ["10.10.0.0/24"]
  location                = azurerm_resource_group.vnetrg.location
  dns_servers             = ["8.8.8.8"]
  flow_timeout_in_minutes = 4

  tags = {
    env = "test"
  }

  encryption = {
    enforcement = "AllowUnencrypted"
  }

  subnet = {
    snet_1 = {
      name                                          = "subnet1"
      address_prefixes                              = ["10.10.0.0/24"]
      default_outbound_access_enabled               = true
      private_endpoint_network_policies             = "Enabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = ["Microsoft.Storage"]

      delegation = [{
        name = "delegation1"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }]
    }
  }
}
