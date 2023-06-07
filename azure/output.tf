output "consul_root_token" {
  value     = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "consul_url" {
  value = hcp_consul_cluster.main.consul_public_endpoint_url
}

output "vm_ssh_key" {
  value = tls_private_key.vms.private_key_pem
  sensitive = true
}

output "tea_customers_ip_address" {
  value = module.tea_customers.public_ip
}

output "tea_catalog_ip_address" {
  value = module.tea_catalog.public_ip
}

output "shipping_ip_address" {
  value = module.shipping.public_ip
}

output "gateway_ip_address" {
  value = module.gateway.public_ip
}

