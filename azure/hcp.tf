
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
  vnet_rg         = azurerm_resource_group.rg.name
  vnet_id         = module.network.vnet_id
  subnet_ids      = module.network.vnet_subnets

  # Optional
  security_group_names = [azurerm_network_security_group.nsg.name]
  prefix               = var.cluster_id
}

resource "hcp_consul_cluster" "main" {
  cluster_id      = var.cluster_id
  hvn_id          = hcp_hvn.hvn.hvn_id
  public_endpoint = true
  tier            = "development"
  size            = "x_small"
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.main.id
}

locals {
  gossip_encryption_key = jsondecode(base64decode(hcp_consul_cluster.main.consul_config_file)).encrypt
}

output "gossip" {
  value = local.gossip_encryption_key
}