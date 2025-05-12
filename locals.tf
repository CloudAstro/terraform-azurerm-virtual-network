locals {
  subnets = var.subnet != null ? {
    for key, subnet_config in var.subnet :
    key => {
      id = [
        for snet in azurerm_virtual_network.virtual_network.subnet :
        snet.id if snet.name == subnet_config.name
      ][0]
      name           = subnet_config.name
      address_prefix = tolist(subnet_config.address_prefixes)[0]
    }
  } : {}
}
