module "gateway" {
  source         = "./mesh_gateway"

  ssh_key        = tls_private_key.vms.public_key_openssh
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