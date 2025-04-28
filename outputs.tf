output "virtual_network" {
  value       = azurerm_virtual_network.virtual_network
  description = <<DESCRIPTION
* `id` - The ID of the virtual network.
* `location` - Location of the virtual network.
* `address_space` - The list of address spaces used by the virtual network.
* `dns_servers` - The list of DNS servers used by the virtual network.
* `guid` - The GUID of the virtual network.
* `subnets` - The list of name of the subnets that are attached to this virtual network.
* `vnet_peerings` - A mapping of name - virtual network id of the virtual network peerings.
* `vnet_peerings_addresses` - A list of virtual network peerings IP addresses.
* `tags` - A mapping of tags to assigned to the resource.

Example output:
```
output "name" {
  value = module.module_name.virtual_network.name
}
```
DESCRIPTION
}
