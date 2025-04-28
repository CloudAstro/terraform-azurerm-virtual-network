resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

module "vnet" {
  source              = "../../"
  name                = "vnet-example"
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.vnetrg.location
}
