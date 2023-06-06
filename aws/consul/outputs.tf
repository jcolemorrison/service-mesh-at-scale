output "transit_gateway_id" {
  description = "Transit gateway for other networks to connect to."
  value = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_cidr_block" {
  description = "Transit gateway cidr for other networks."
  value = var.transit_gateway_cidr_block
}

output "ram_resource_arns" {
  description = "Map of AWS Resource Access Manager IDs for the external accounts to use as a share accepter"
  value = zipmap(aws_ram_principal_association.tgw[*].principal, aws_ram_resource_share.tgw[*].arn)
}

output "hcp_consul_cluster_id" {
  description = "Cluster ID of the HCP Consul Cluster"
  value = hcp_consul_cluster.aws.cluster_id
}

output "hcp_consul_cluster_id_id" {
  description = "Cluster ID...ID of the HCP Consul Cluster"
  value = hcp_consul_cluster.aws.id
}

output "hcp_consul_root_token_secret_id" {
  description = "root token ID of the consul cluster needed in other ECS projects for ACL bootstrapping"
  value = hcp_consul_cluster.aws.consul_root_token_secret_id
  sensitive = true
}

output "hcp_consul_gossip_key" {
  description = "gossip key used by all clients"
  value = jsondecode(base64decode(hcp_consul_cluster.aws.consul_config_file))["encrypt"]
  sensitive = true
}

output "hcp_consul_ca_file" {
  description = "CA file used by consul clients for mtls.  comes base64 encoded"
  value = hcp_consul_cluster.aws.consul_ca_file
  sensitive = true
}

output "hcp_consul_public_endpoint" {
  description = "public endpoint of the HCP consul cluster"
  value = hcp_consul_cluster.aws.consul_public_endpoint_url
}

output "hcp_consul_private_endpoint" {
  description = "private endpoint of the HCP consul cluster"
  value = hcp_consul_cluster.aws.consul_private_endpoint_url
}

output "hcp_datacenter" {
  description = "datacenter of the cluster"
  value = hcp_consul_cluster.aws.datacenter
}