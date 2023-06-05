
//provider "consul" {
//  address    = hcp_consul_cluster.main.consul_public_endpoint_url
//  datacenter = hcp_consul_cluster.main.datacenter
//  token      = hcp_consul_cluster_root_token.token.secret_id
//}

resource "random_id" "hvn" {
  byte_length = 8
}

resource "hcp_hvn" "hvn" {
  hvn_id         = "${var.cluster_id}-${random_id.hvn.hex}"
  cloud_provider = "azure"
  region         = var.region
  cidr_block     = "172.25.32.0/20"
}

module "hcp_peering" {
  source  = "./hcp_peering"

  # Required
  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id
  hvn             = hcp_hvn.hvn
  vnet_rg         = var.resource_group_name
  vnet_id         = module.network.vnet_id
  subnet_ids      = module.network.vnet_subnets
  subnet_cidrs    = var.vnet_cidrs

  # Optional
  security_group_names = [azurerm_network_security_group.nsg.name]
  prefix               = var.cluster_id
  region = var.region
}

resource "hcp_consul_cluster" "main" {
  cluster_id      = var.cluster_id
  hvn_id          = hcp_hvn.hvn.hvn_id
  public_endpoint = true
  tier            = "standard"
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.main.id
}

output "consul_root_token" {
  value     = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "consul_url" {
  value = hcp_consul_cluster.main.consul_public_endpoint_url
}