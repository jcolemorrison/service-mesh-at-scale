resource "tls_private_key" "vms" {
  algorithm   = "RSA"
  rsa_bits = "4096"
}

module "tea_customers" {
  source         = "./application_vm"

  ssh_key        = tls_private_key.vms.public_key_openssh
  service        = "tea-customers"
  location       = var.region
  resource_group = var.resource_group_name
  subnet_id      = module.network.vnet_subnets.0

  consul_server_private_addr  = hcp_consul_cluster.main.consul_private_endpoint_url
  consul_server_public_addr   = hcp_consul_cluster.main.consul_public_endpoint_url
  datacenter                  = hcp_consul_cluster.main.datacenter
  token                       = hcp_consul_cluster_root_token.token.secret_id
  auth_method                 = consul_acl_auth_method.azure_jwt.name
  consul_ca                   = hcp_consul_cluster.main.consul_ca_file
  network_security_group_name = azurerm_network_security_group.nsg.name
  gossip_encryption_key       = local.gossip_encryption_key
}

module "tea_catalog" {
  source         = "./application_vm"

  ssh_key        = tls_private_key.vms.public_key_openssh
  service        = "tea-catalog"
  location       = var.region
  resource_group = var.resource_group_name
  subnet_id      = module.network.vnet_subnets.0

  consul_server_private_addr  = hcp_consul_cluster.main.consul_private_endpoint_url
  consul_server_public_addr   = hcp_consul_cluster.main.consul_public_endpoint_url
  datacenter                  = hcp_consul_cluster.main.datacenter
  token                       = hcp_consul_cluster_root_token.token.secret_id
  auth_method                 = consul_acl_auth_method.azure_jwt.name
  consul_ca                   = hcp_consul_cluster.main.consul_ca_file
  network_security_group_name = azurerm_network_security_group.nsg.name
  gossip_encryption_key       = local.gossip_encryption_key
}

module "shipping" {
  source         = "./application_vm"

  ssh_key        = tls_private_key.vms.public_key_openssh
  service        = "shipping"
  location       = var.region
  resource_group = var.resource_group_name
  subnet_id      = module.network.vnet_subnets.0

  consul_server_private_addr  = hcp_consul_cluster.main.consul_private_endpoint_url
  consul_server_public_addr   = hcp_consul_cluster.main.consul_public_endpoint_url
  datacenter                  = hcp_consul_cluster.main.datacenter
  token                       = hcp_consul_cluster_root_token.token.secret_id
  auth_method                 = consul_acl_auth_method.azure_jwt.name
  consul_ca                   = hcp_consul_cluster.main.consul_ca_file
  network_security_group_name = azurerm_network_security_group.nsg.name
  gossip_encryption_key       = local.gossip_encryption_key
}