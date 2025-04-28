variable "name" {
  type        = string
  description = <<DESCRIPTION
  * `name` - (Required) The name of the virtual network. Changing this forces a new resource to be created.

  Example input:
  ```
  name = "vnet-gwc-hub"
  ```
  DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
  * `resource_group_name` - (Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created.

  Example input:
  ```
  resource_group_name = "rg-vnet-gwc-hub"
  ```
  DESCRIPTION
}

variable "address_space" {
  type        = list(string)
  description = <<DESCRIPTION
  * `address_space` - (Required) The address space that is used the virtual network. You can supply more than one address space.

  Example input:
  ```
  address_space = ["10.10.0.0/16", "172.19.1.0/24" ]
  ```
  DESCRIPTION
}

variable "location" {
  type        = string
  nullable    = false
  description = <<DESCRIPTION
  * `location` - (Required) The location/region where the virtual network is created. Changing this forces a new resource to be created.

  Example input:
  ```
  location = "germanywestcentral"
  ```
  DESCRIPTION
}

variable "bgp_community" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `bgp_community` - (Optional) The BGP community attribute in format `<as-number>:<community-value>`.

-> **Note:** The `as-number` segment is the Microsoft ASN, which is always `12076` for now.
  Example input:
  ```
  bgp_community = "<as-number>:<community-value>"
  ```
  DESCRIPTION
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = <<DESCRIPTION
* `dns_servers` - (Optional) List of IP addresses of DNS servers

-> **Note:** Since `dns_servers` can be configured both inline and via the separate `azurerm_virtual_network_dns_servers` resource, we have to explicitly set it to empty slice (`[]`) to remove it.

  Example input:
  ```
  dns_servers = ["1.1.1.1", "8.8.8.8"]
  ```
  DESCRIPTION
}

variable "edge_zone" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `edge_zone` - (Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created.

  Example input:
  ```
  edge_zone = "attatlanta1" # AT&T
  ```
  DESCRIPTION
}

variable "flow_timeout_in_minutes" {
  type        = number
  default     = 4
  description = <<DESCRIPTION
  * `flow_timeout_in_minutes` - (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes.

  Example input:
  ```
  flow_timeout_in_minutes = 10
  ```
  DESCRIPTION
}

variable "private_endpoint_vnet_policies" {
  type        = string
  default     = "Disabled"
  description = <<DESCRIPTION
* `private_endpoint_vnet_policies` - (Optional) The Private Endpoint VNet Policies for the Virtual Network. Possible values are `Disabled` and `Basic`. Defaults to `Disabled`.

  Example input:
  ```
  private_endpoint_vnet_policies = "Disabled"
  ```
  DESCRIPTION
}


variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  * `tags` - (Optional) A mapping of tags to assign to the resource.

  Example input:
  ```
  tags = {
    env     = prod
    region  = gwc
  }
  ```
  DESCRIPTION
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  default     = null
  description = <<DESCRIPTION
* `ddos_protection_plan` - (Optional) A `ddos_protection_plan` block as documented below.
---
A `ddos_protection_plan` block supports the following:
  * `id` - (Required) The ID of DDoS Protection Plan.
  * `enable` - (Required) Enable/disable DDoS Protection Plan on Virtual Network.

  Example input:
  ```
  ddos_protection_plan = {
    id      = azurerm_network_ddos_protection_plan.resource.id
    enable  = true
  }
  ```
  DESCRIPTION
}

variable "encryption" {
  type = object({
    enforcement = optional(string, "AllowUnencrypted")
  })
  default     = null
  description = <<DESCRIPTION
* `encryption` - (Optional) A `encryption` block as defined below.
---
A `encryption` block supports the following:
  * `enforcement` - (Required) Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values are `DropUnencrypted` and `AllowUnencrypted`.

  -> **Note:** Currently `AllowUnencrypted` is the only supported value for the `enforcement` property as `DropUnencrypted` is not yet in public preview or general availability. Please see the [official documentation](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-encryption-overview#limitations) for more information.

  Example input:
  ```
  ddos_protection_plan = {
    id      = azurerm_network_ddos_protection_plan.resource.id
    enable  = true
  }
  ```
  DESCRIPTION
}


variable "subnet" {
  type = map(object({
    name                                          = string
    address_prefixes                              = set(string)
    security_group                                = optional(string)
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    route_table_id                                = optional(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    delegation = optional(list(object({
      name = string
      service_delegation = optional(object({
        name    = string
        actions = optional(list(string))
      }))
    })))
  }))
  default     = null
  description = <<DESCRIPTION
* `subnet` - (Optional) Can be specified multiple times to define multiple subnets. Each `subnet` block supports fields documented below.

-> **Note:** Since `subnet` can be configured both inline and via the separate `azurerm_subnet` resource, we have to explicitly set it to empty slice (`[]`) to remove it.
---
The `subnet` block supports:
  * `name` - (Required) The name of the subnet.
  * `address_prefixes` - (Required) The address prefixes to use for the subnet.
  * `security_group` - (Optional) The Network Security Group to associate with the subnet. (Referenced by `id`, i.e. `azurerm_network_security_group.example.id`)
  * `default_outbound_access_enabled` - (Optional) Enable default outbound access to the internet for the subnet. Defaults to `true`.
  * `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Disabled`.

  -> **Note:** If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set `private_endpoint_network_policies` in the subnet to `Disabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.

  -> **Note:** If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the `private_endpoint_network_policies` in the Subnet to `Enabled`/`NetworkSecurityGroupEnabled`/`RouteTableEnabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.

  -> **Note:** See more details from [Manage network policies for Private Endpoints](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal).
  * `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to `true`.

  -> **Note:** When configuring Azure Private Link service, the explicit setting `private_link_service_network_policies_enabled` must be set to `false` in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups. This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource. See more details from [Manage network policies for Private Link Services](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell).
  * `route_table_id` - (Optional) The ID of the Route Table that should be associated with this subnet.
  * `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.
  * `service_endpoint_policy_ids` - (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
  * `delegation` - (Optional) One or more `delegation` blocks as defined below.

---
A `delegation` block supports the following:
  * `name` - (Required) A name for this delegation.
  * `service_delegation` - (Required) A `service_delegation` block as defined below.

---
A `service_delegation` block supports the following:

-> **Note:** Delegating to services may not be available in all regions. Check that the service you are delegating to is available in your region using the [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations). Also, `actions` is specific to each service type. The exact list of `actions` needs to be retrieved using the aforementioned [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations).
  * `name` - (Required) The name of service to delegate to. Possible values are `GitHub.Network/networkSettings`, `Informatica.DataManagement/organizations`, `Microsoft.ApiManagement/service`, `Microsoft.Apollo/npu`, `Microsoft.App/environments`, `Microsoft.App/testClients`, `Microsoft.AVS/PrivateClouds`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureHostedService`, `Microsoft.BareMetal/AzureHPC`, `Microsoft.BareMetal/AzurePaymentHSM`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.BareMetal/MonitoringServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.CloudTest/hostedpools`, `Microsoft.CloudTest/images`, `Microsoft.CloudTest/pools`, `Microsoft.Codespaces/plans`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.ContainerService/TestClients`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/servers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.DelegatedNetwork/controller`, `Microsoft.DevCenter/networkConnection`, `Microsoft.DevOpsInfrastructure/pools`, `Microsoft.DocumentDB/cassandraClusters`, `Microsoft.Fidalgo/networkSettings`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.LabServices/labplans`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/applicationGateways`, `Microsoft.Network/dnsResolvers`, `Microsoft.Network/managedResolvers`, `Microsoft.Network/fpgaNetworkInterfaces`, `Microsoft.Network/networkWatchers.`, `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerAutomate/hostedRpa`, `Microsoft.PowerPlatform/enterprisePolicies`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.ServiceNetworking/trafficControllers`, `Microsoft.Singularity/accounts/networks`, `Microsoft.Singularity/accounts/npu`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/managedInstancesOnebox`, `Microsoft.Sql/managedInstancesStage`, `Microsoft.Sql/managedInstancesTest`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments`, `PaloAltoNetworks.Cloudngfw/firewalls`, `Qumulo.Storage/fileSystems`, and `Oracle.Database/networkAttachments`.
  * `actions` - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/publicIPAddresses/join/action`, `Microsoft.Network/publicIPAddresses/read`, `Microsoft.Network/virtualNetworks/read`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action`, and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.

  -> **Note:** Azure may add default actions depending on the service delegation name and they can't be changed.

  Example input:
  ```
  subnet = {
    snet_aks = {
      name           = "snet-aks"
      address_prefixes = ["10.10.0.0/22"]
      security_group = "azurerm_network_security_group.example.id"
    }
    snet_appgw = {
      name             = "snet-apgw"
      address_prefixes = ["10.10.1.0/28"]
      security_group   = "azurerm_network_security_group.example.id"
    }
  }
  ```
  DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string, "30")
    read   = optional(string, "5")
    update = optional(string, "30")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
---
The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
  * `create` - (Defaults to 30 minutes) Used when creating the Subnet.
  * `read` - (Defaults to 5 minutes) Used when retrieving the Subnet.
  * `update` - (Defaults to 30 minutes) Used when updating the Subnet.
  * `delete` - (Defaults to 30 minutes) Used when deleting the Subnet.
DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                           = string
    target_resource_id             = optional(string)
    eventhub_name                  = optional(string)
    eventhub_authorization_rule_id = optional(string)
    log_analytics_workspace_id     = optional(string)
    storage_account_id             = optional(string)
    log_analytics_destination_type = optional(string)
    partner_solution_id            = optional(string)
    enabled_log = optional(set(object({
      category       = optional(string)
      category_group = optional(string)
    })))
    metric = optional(set(object({
      category = string
      enabled  = optional(bool, true)
    })))
    timeouts = optional(object({
      create = optional(string, "30")
      update = optional(string, "30")
      read   = optional(string, "5")
      delete = optional(string, "60")
    }))
  }))
  default     = null
  description = <<DESCRIPTION
* `monitor_diagnostic_setting` - (Optional) The `monitor_diagnostic_setting` block resource as defined below.
---
  * `name` - (Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created.

  -> **Note:** If the name is set to 'service' it will not be possible to fully delete the diagnostic setting. This is due to legacy API support.
  * `target_resource_id` - (Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created.
  * `eventhub_name` - (Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent.

  -> **Note:** If this isn't specified then the default Event Hub will be used.
  * `eventhub_authorization_rule_id` - (Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data.

  -> **Note:** This can be sourced from [the `azurerm_eventhub_namespace_authorization_rule` resource](eventhub_namespace_authorization_rule.html) and is different from [a `azurerm_eventhub_authorization_rule` resource](eventhub_authorization_rule.html).

  -> **Note:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
  * `log_analytics_workspace_id` - (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent.

  -> **Note:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
  * `storage_account_id` - (Optional) The ID of the Storage Account where logs should be sent.

  -> **Note:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
  * `log_analytics_destination_type` - (Optional) Possible values are `AzureDiagnostics` and `Dedicated`. When set to `Dedicated`, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy `AzureDiagnostics` table.

  -> **Note:** This setting will only have an effect if a `log_analytics_workspace_id` is provided. For some target resource type (e.g., Key Vault), this field is unconfigurable. Please see [resource types](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#resource-types) for services that use each method. Please [see the documentation](https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-log-store#azure-diagnostics-vs-resource-specific) for details on the differences between destination types.
  * `partner_solution_id` - (Optional) The ID of the market partner solution where Diagnostics Data should be sent. For potential partner integrations, [click to learn more about partner integration](https://learn.microsoft.com/en-us/azure/partner-solutions/overview).

  -> **Note:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
  * `enabled_log` - (Optional) One or more `enabled_log` blocks as defined below.

  -> **Note:** At least one `enabled_log` or `metric` block must be specified. At least one type of Log or Metric must be enabled.
  * `metric` - (Optional) One or more `metric` blocks as defined below.

  -> **Note:** At least one `enabled_log` or `metric` block must be specified.

---
An `enabled_log` block supports the following:
  * `category` - (Optional) The name of a Diagnostic Log Category for this Resource.

  -> **Note:** The Log Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor_diagnostic_categories.html) or [list of service specific schemas](https://docs.microsoft.com/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas) to identify which categories are available for a given Resource.
  * `category_group` - (Optional) The name of a Diagnostic Log Category Group for this Resource.

  -> **Note:** Not all resources have category groups available.

  -> **Note:** Exactly one of `category` or `category_group` must be specified.

---
A `metric` block supports the following:
  * `category` - (Required) The name of a Diagnostic Metric Category for this Resource.

  -> **Note:** The Metric Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor_diagnostic_categories.html) to identify which categories are available for a given Resource.
  * `enabled` - (Optional) Is this Diagnostic Metric enabled? Defaults to `true`.

---
The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
  * `create` - (Defaults to 30 minutes) Used when creating the Diagnostics Setting.
  * `update` - (Defaults to 30 minutes) Used when updating the Diagnostics Setting.
  * `read` - (Defaults to 5 minutes) Used when retrieving the Diagnostics Setting.
  * `delete` - (Defaults to 60 minutes) Used when deleting the Diagnostics Setting.

  Example Input:
  ```
  diagnostic_settings = {
   "vnet-diagnostic" = {
    name                           = "vnet-diagnostic-setting"
    target_resource_id             = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>"
    eventhub_name                  = null
    eventhub_authorization_rule_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.EventHub/namespaces/<eventhub-namespace>/authorizationRules/<auth-rule-name>"
    log_analytics_workspace_id     = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>"
    storage_account_id             = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    log_analytics_destination_type = "AzureDiagnostics"
    partner_solution_id            = null
      enabled_log = [
        {
          category       = "VirtualNetworkGatewayLogs"
          category_group = null
        },
        {
          category       = "FlowLogs"
          category_group = null
        }
      ]
      metric = {
        category = "AllMetrics"
        enabled  = true
      }
    }
  }
  ```
  DESCRIPTION
}
