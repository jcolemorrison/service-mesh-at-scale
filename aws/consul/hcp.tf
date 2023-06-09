resource "hcp_consul_cluster" "aws" {
  cluster_id      = "aws"
  hvn_id          = hcp_hvn.hvn_service_mesh_at_scale.hvn_id
  tier            = "development"
  project_id      = var.hcp_project_id
  size            = "x_small"
  public_endpoint = true
}
