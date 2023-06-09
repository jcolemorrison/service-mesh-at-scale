# A Generalized group for all consul catalogs
resource "aws_security_group" "consul_catalog" {
  name_prefix = "${local.project_tag}-consul-catalog-"
  description = "General security group for consul catalogs."
  vpc_id      = aws_vpc.main.id
}

# Required for gossip traffic between each catalog
resource "aws_security_group_rule" "consul_catalog_allow_inbound_self_8301" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}

# Required for gossip traffic between each catalog
resource "aws_security_group_rule" "consul_catalog_allow_inbound_self_8301_udp" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "ingress"
  protocol          = "udp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}


# Required for gossip traffic from catalogs to HCP HVN
resource "aws_security_group_rule" "consul_catalog_allow_inbound_HCP_8301_tcp" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks = [ data.hcp_hvn.aws.cidr_block ]
  from_port         = 8301
  to_port           = 8301
  description       = "Allow TCP traffic from HCP with this security group."
}

resource "aws_security_group_rule" "consul_catalog_allow_inbound_HCP_8301_udp" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks = [ data.hcp_hvn.aws.cidr_block ]
  from_port         = 8301
  to_port           = 8301
  description       = "Allow UDP traffic from HCP with this security group."
}


# Allow inbound from HCP HVN
# resource "aws_security_group_rule" "consul_catalog_allow_inbound_HVN" {
#   security_group_id = aws_security_group.consul_catalog.id
#   type              = "ingress"
#   protocol          = "tcp"
#   cidr_blocks = [ data.hcp_hvn.aws.cidr_block ]
#   from_port         = 8500
#   to_port           = 8501
#   description       = "Allow HTTP(S) traffic from from the HCP HVN."
# }

# Required to allow the proxies to contact each other
resource "aws_security_group_rule" "consul_catalog_allow_inbound_self_20000" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 20000
  to_port           = 20000
  description       = "Allow Proxy traffic from resources with this security group."
}

resource "aws_security_group_rule" "consul_catalog_allow_outbound" {
  security_group_id = aws_security_group.consul_catalog.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

# Security Group for ECS catalog Service.
resource "aws_security_group" "ecs_catalog_service" {
  name_prefix = "${local.project_tag}-ecs-catalog-service"
  description = "ECS catalog service security group."
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_catalog_service_allow_9090" {
  security_group_id = aws_security_group.ecs_catalog_service.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 9090
  to_port           = 9090
  source_security_group_id = aws_security_group.catalog_alb.id
  description       = "Allow incoming traffic from the catalog ALB into the service container port."
}

resource "aws_security_group_rule" "ecs_catalog_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_catalog_service.id
  type = "ingress"
  protocol = -1
  self = true
  from_port = 0
  to_port = 0
  description = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_catalog_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_catalog_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}