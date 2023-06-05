# resource "hcp_consul_cluster" "smas" {
#   cluster_id = "smas-aws-consul-cluster"
#   hvn_id     = hcp_hvn.hvn_service_mesh_at_scale.hvn_id
#   tier       = "standard"
#   project_id = var.hcp_project_id
#   size = "small"
# }