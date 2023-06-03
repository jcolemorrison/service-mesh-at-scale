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
  value = zipmap(aws_ram_resource_share.main[*].arn, aws_ram_principal_association.main[*].principal)
}