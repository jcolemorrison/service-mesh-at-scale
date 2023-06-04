resource "hcp_hvn" "hvn_service_mesh_at_scale" {
  hvn_id         = "hvn-service-mesh-at-scale"
  cloud_provider = "aws"
  region         = var.aws_default_region
  cidr_block     = var.hvn_cidr_block
  project_id     = var.hcp_project_id
}

resource "hcp_aws_transit_gateway_attachment" "tgw" {
  depends_on = [
    aws_ram_principal_association.tgw,
    aws_ram_resource_association.tgw,
  ]

  hvn_id                        = hcp_hvn.hvn_service_mesh_at_scale.hvn_id
  transit_gateway_attachment_id = "hvn-tgw-attachment"
  transit_gateway_id            = aws_ec2_transit_gateway.main.id
  resource_share_arn            = aws_ram_resource_share.tgw.arn
}


# one of these will be needed for each hub vpc
resource "hcp_hvn_route" "tgw" {
  count            = length(var.spoke_vpc_cidrs) > 0 ? length(var.spoke_vpc_cidrs) : 0
  hvn_link         = hcp_hvn.hvn_service_mesh_at_scale.self_link
  hvn_route_id     = "hvn-to-tgw-attachment-${var.spoke_vpc_cidrs[count.index]}"
  destination_cidr = var.spoke_vpc_cidrs[count.index]
  target_link      = hcp_aws_transit_gateway_attachment.tgw.self_link
  project_id = var.hcp_project_id
}