## The Transit Gateway Resource
resource "aws_ec2_transit_gateway" "main" {
  description = "Transit gateway."

  # Used as a unique identifier for this autonomous system (network) on AWS side 
  # amazon_side_asn = 64512 # specify this or use the default

  # Accounts attaching to this gateway create their own attachment.  If this is disabled
  # this account has to manually accept every attachment.  This is set to enabled here
  # because for the attachment to take place, this account would've already cleared
  # the acceptance in the form of an AWS RAM.
  #
  # If this is disabled, you'll need a "aws_ram_resource_share_accepter" resource
  # in all connecting accounts.
  auto_accept_shared_attachments = "enable"

  # versus managing your own
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  # Allow for DNS resolution across attached VPCs
  dns_support = "enable"

  # Allow Multicast between attached VPCs through the Transit Gateway.  TGWs support everything
  # needed for this natively.
  multicast_support = "disable"

  # Not in a VPC, just the private range, within your account, this exists at.  Almost as if
  # its it's own VPC.  This can be anything but a CIDR block used for a VPC in your account or
  # anything in the "169.254.0.0/16" range.
  transit_gateway_cidr_blocks = [var.transit_gateway_cidr_block]

  tags = { "Name" = "${local.project_tag}-tgw" }
}

# If we have any accounts we're trying to share our transit gateway with, create RAMs
resource "aws_ram_resource_share" "tgw" {
  count = length(local.shared_account_principals) > 0 ? 1 : 0
  name = "tgw"
  allow_external_principals = true
  tags = { "Name" = "${local.project_tag}-tgw-ram" }
}

# share the transit gateway
resource "aws_ram_resource_association" "tgw" {
  count = length(local.shared_account_principals) > 0 ? 1 : 0
  resource_arn = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}

# share with specified principals
resource "aws_ram_principal_association" "tgw" {
  count = length(local.shared_account_principals) > 0 ? length(local.shared_account_principals) : 0
  principal = local.shared_account_principals[count.index]
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}