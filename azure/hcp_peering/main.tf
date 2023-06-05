locals {
  ingress_consul_rules = [
    {
      description = "Consul LAN Serf (tcp)"
      rule_name   = "consul-lan-tcp"
      port        = 8301
      protocol    = "Tcp"
    },
    {
      description = "Consul LAN Serf (udp)"
      rule_name   = "consul-lan-udp"
      port        = 8301
      protocol    = "Udp"
    },
  ]

  # If a list of security_group_ids was provided, construct a rule set.
  hcp_consul_security_groups = flatten([
    for _, sg in var.security_group_names : [
      for i, rule in local.ingress_consul_rules : {
        security_group_name = sg
        description         = rule.description
        destination_port    = rule.port
        protocol            = rule.protocol
        rule_name           = rule.rule_name
      }
    ]
  ])
}

resource "hcp_azure_peering_connection" "peering" {
  hvn_link                 = var.hvn.self_link
  peering_id               = var.prefix
  peer_vnet_name           = var.vnet_id
  peer_subscription_id     = var.subscription_id
  peer_tenant_id           = var.tenant_id
  peer_resource_group_name = var.vnet_rg
  peer_vnet_region         = var.region
}

data "azuread_client_config" "current" {}

resource "azuread_service_principal" "principal" {
  application_id = hcp_azure_peering_connection.peering.application_id
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_definition" "definition" {
  name  = var.prefix
  scope = var.vnet_id
  assignable_scopes = [
    var.vnet_id
  ]
  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write"
    ]
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  principal_id       = azuread_service_principal.principal.id
  role_definition_id = azurerm_role_definition.definition.role_definition_resource_id
  scope              = var.vnet_id
}

//data "hcp_azure_peering_connection" "peering" {
//  hvn_link              = var.hvn.self_link
//  peering_id            = hcp_azure_peering_connection.peering.peering_id
//  wait_for_active_state = true
//}
//
//# HVN route tables to point to subnets
//resource "hcp_hvn_route" "route" {
//  count        = length(var.subnet_cidrs)
//  hvn_link     = var.hvn.self_link
//  hvn_route_id = "${var.prefix}-${count.index}"
//  # TODO: handle multiple cidrs attached to a single subnet. Taking first for now
//  destination_cidr = var.subnet_cidrs[count.index]
//  target_link      = data.hcp_azure_peering_connection.peering.self_link
//}
//
//resource "azurerm_network_security_rule" "hcp_consul_existing_sg_rules" {
//  count                       = length(local.hcp_consul_security_groups)
//  name                        = "${var.prefix}-${local.hcp_consul_security_groups[count.index].rule_name}"
//  priority                    = 100 + count.index
//  direction                   = "Inbound"
//  access                      = "Allow"
//  description                 = local.hcp_consul_security_groups[count.index].description
//  protocol                    = local.hcp_consul_security_groups[count.index].protocol
//  source_port_range           = "*"
//  destination_port_range      = local.hcp_consul_security_groups[count.index].destination_port
//  source_address_prefix       = var.hvn.cidr_block
//  destination_address_prefix  = "*"
//  resource_group_name         = var.vnet_rg
//  network_security_group_name = local.hcp_consul_security_groups[count.index].security_group_name
//}
//
//# If no security_group_names were provided, create a new security_group.
//resource "azurerm_network_security_group" "nsg" {
//  count               = length(var.security_group_names) == 0 ? 1 : 0
//  name                = var.prefix
//  location            = var.region
//  resource_group_name = var.vnet_rg
//}
//
//# If no security_group_names were provided associate the new security 
//# group with all the subnets
//resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
//  count                     = length(var.security_group_names) == 0 ? length(var.subnet_ids) : 0
//  subnet_id                 = var.subnet_ids[count.index]
//  network_security_group_id = azurerm_network_security_group.nsg[0].id
//}
//
//# If no security_group_ids were provided, use the new security_group.
//resource "azurerm_network_security_rule" "hcp_consul_new_sg_rules" {
//  count                       = length(var.security_group_names) == 0 ? length(local.ingress_consul_rules) : 0
//  name                        = "${var.prefix}-${local.ingress_consul_rules[count.index].rule_name}"
//  priority                    = 100 + count.index
//  direction                   = "Inbound"
//  access                      = "Allow"
//  protocol                    = local.ingress_consul_rules[count.index].protocol
//  source_port_range           = "*"
//  destination_port_range      = local.ingress_consul_rules[count.index].port
//  source_address_prefix       = var.hvn.cidr_block
//  destination_address_prefix  = "*"
//  resource_group_name         = var.vnet_rg
//  network_security_group_name = azurerm_network_security_group.nsg[0].name
//}