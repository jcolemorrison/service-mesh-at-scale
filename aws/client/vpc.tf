# Main VPC resource
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.vpc_instance_tenancy
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = { "Name" = "${local.project_tag}-vpc" }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = { "Name" = "${local.project_tag}-igw" }
}

## Egress Only Gateway (IPv6)
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.main.id
}


## The NAT Elastic IP
resource "aws_eip" "nat" {
  vpc = true

  tags = { "Name" = "${local.project_tag}-nat-eip" }

  depends_on = [aws_internet_gateway.igw]
}

## The NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id

  tags = { "Name" = "${local.project_tag}-nat" }

  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat
  ]
}

## Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = { "Name" = "${local.project_tag}-public-rtb" }
}

## Public routes
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

## Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = { "Name" = "${local.project_tag}-private-rtb" }
}

## Private Routes
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "private_internet_access_ipv6" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw.id
}

## Public Subnets
resource "aws_subnet" "public" {
  count = var.vpc_public_subnet_count

  vpc_id = aws_vpc.main.id

  # create subnets based on the vpc's cidr_block and chosen count
  # cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  cidr_block              = local.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  # create ipv6 subnets based on the vpc's cidr_block and chosen count
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true

  tags = { "Name" = "${local.project_tag}-public-${data.aws_availability_zones.available.names[count.index]}" }
}

## Private Subnets
resource "aws_subnet" "private" {
  count = var.vpc_private_subnet_count

  vpc_id = aws_vpc.main.id

  // Increment the netnum by the number of public subnets to avoid overlap
  # cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.vpc_public_subnet_count)
  cidr_block = local.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { "Name" = "${local.project_tag}-private-${data.aws_availability_zones.available.names[count.index]}" }
}

## Public Subnet Route Associations
resource "aws_route_table_association" "public" {
  count = var.vpc_public_subnet_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

## Private Subnet Route Associations
resource "aws_route_table_association" "private" {
  count = var.vpc_private_subnet_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Transit Gateway Attachment Configuration
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  transit_gateway_id = var.transit_gateway_id
  
  # vpc to attach to our transit gateway
  vpc_id = aws_vpc.main.id

  # the ids of...the subnets the transit gateway will be made available to inside of the attached VPC
  subnet_ids = aws_subnet.private.*.id

  # can DNS be resolved across the transit gateway?  enabled so that load balancer DNS and service
  # DNS can still be resolved.
  dns_support = "enable"

  # across traffic in the transit gateway...though since IPv6 is public by default, is this needed?
  ipv6_support = "disable"

  # whether or not to both associate and propagate routes from the VPC onto the transit gateway's
  # default route table.
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = { "Name" = "${local.project_tag}-tgw-attach-main" }
}

# Private routing table route attachment.  Any traffic destined for the HVN CIDR goes to the TGW.
resource "aws_route" "private_hcp_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = data.hcp_hvn.aws.cidr_block
  transit_gateway_id = var.transit_gateway_id
}

# Public routing table route attachment.  Any traffic destined for the HVN CIDR goes to the TGW.
resource "aws_route" "public_hcp_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = data.hcp_hvn.aws.cidr_block
  transit_gateway_id = var.transit_gateway_id
}