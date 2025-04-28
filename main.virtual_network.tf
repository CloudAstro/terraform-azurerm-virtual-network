resource "azurerm_virtual_network" "virtual_network" {
  name                           = var.name
  resource_group_name            = var.resource_group_name
  address_space                  = var.address_space
  location                       = var.location
  bgp_community                  = var.bgp_community
  dns_servers                    = var.dns_servers
  edge_zone                      = var.edge_zone
  flow_timeout_in_minutes        = var.flow_timeout_in_minutes
  private_endpoint_vnet_policies = var.private_endpoint_vnet_policies
  tags                           = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  dynamic "subnet" {
    for_each = var.subnet != null ? var.subnet : {}

    content {
      name                                          = subnet.value.name
      address_prefixes                              = subnet.value.address_prefixes
      security_group                                = subnet.value.security_group
      default_outbound_access_enabled               = subnet.value.default_outbound_access_enabled
      private_endpoint_network_policies             = subnet.value.private_endpoint_network_policies
      private_link_service_network_policies_enabled = subnet.value.private_link_service_network_policies_enabled
      route_table_id                                = subnet.value.route_table_id
      service_endpoints                             = subnet.value.service_endpoints
      service_endpoint_policy_ids                   = subnet.value.service_endpoint_policy_ids

      dynamic "delegation" {
        for_each = subnet.value.delegation != null ? subnet.value.delegation : []
        content {
          name = delegation.value.name

          dynamic "service_delegation" {
            for_each = delegation.value.service_delegation != null ? [delegation.value.service_delegation] : []
            content {
              name    = service_delegation.value.name
              actions = service_delegation.value.actions
            }
          }
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

# monitor_diagnostic_setting
resource "azurerm_monitor_diagnostic_setting" "virtual_network" {
  for_each = var.diagnostic_settings == null ? {} : var.diagnostic_settings

  name                           = each.value.name
  target_resource_id             = azurerm_virtual_network.virtual_network.id
  eventhub_name                  = each.value.eventhub_name
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  storage_account_id             = each.value.storage_account_id
  partner_solution_id            = each.value.partner_solution_id

  dynamic "enabled_log" {
    for_each = each.value.enabled_log != null ? each.value.enabled_log : []
    content {
      category       = enabled_log.value.category_group == null ? enabled_log.value.category : null
      category_group = enabled_log.value.category_group
    }
  }

  dynamic "metric" {
    for_each = each.value.metric != null ? each.value.metric : []
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}
