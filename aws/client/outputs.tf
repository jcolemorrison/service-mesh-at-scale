output "retry_join_dns" {
  value = jsondecode(base64decode(data.hcp_consul_cluster.aws.consul_config_file))["retry_join"]
}