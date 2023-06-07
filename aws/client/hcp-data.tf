data "hcp_consul_cluster" "aws" {
  cluster_id = var.hcp_consul_cluster_id
}

data "hcp_hvn" "aws" {
  hvn_id = var.hvn_id
}