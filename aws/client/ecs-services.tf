module "consul_acl_controller" {
  source  = "hashicorp/consul-ecs/aws//modules/acl-controller"
  version = "0.6.0"

  name_prefix     = local.project_tag
  ecs_cluster_arn = aws_ecs_cluster.main.arn
  region          = var.aws_default_region
  launch_type = "FARGATE"
  # mapped to an underlying `aws_ecs_service` resource, so its the same format
  security_groups = [aws_security_group.consul_client.id]
  subnets = aws_subnet.private.*.id

  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.consul_bootstrap_token.arn
  # consul_server_ca_cert_arn         = aws_secretsmanager_secret.consul_root_ca_cert.arn # apparently not required with HCP...
  consul_server_http_addr = "${data.hcp_consul_cluster.aws.consul_private_endpoint_url}"

  # the ACL controller module creates the required IAM role to allow logging
  log_configuration = local.acl_logs_configuration

  # Admin Partitions
  consul_partitions_enabled = true  
  consul_partition = "default"

  depends_on = [
    aws_nat_gateway.nat,
  ]
}

module "mesh_gateway" {
  source  = "hashicorp/consul-ecs/aws//modules/gateway-task"
  version = "0.6.0"
  family = "aws-mesh-gateway"
  ecs_cluster_arn = aws_ecs_cluster.main.arn

  subnets = aws_subnet.private.*.id # where the mesh gateway exists
  security_groups = [aws_security_group.consul_client.id]
  log_configuration = local.mesh_gateway_log_configuration
  retry_join = jsondecode(base64decode(data.hcp_consul_cluster.aws.consul_config_file))["retry_join"]
  kind = "mesh-gateway"
  consul_datacenter = data.hcp_consul_cluster.aws.datacenter
  consul_primary_datacenter = data.hcp_consul_cluster.aws.datacenter # required for mesh gateways?
  tls = true
  gossip_key_secret_arn = aws_secretsmanager_secret.consul_gossip_key.arn

  # not 100 if this is required, but it's present in the other ecs tasks and services
  additional_task_role_policies = [aws_iam_policy.execute_command.arn]

  acls = true
  consul_http_addr = "${data.hcp_consul_cluster.aws.consul_private_endpoint_url}"
  # consul_https_ca_cert_arn = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_server_ca_cert_arn = aws_secretsmanager_secret.consul_root_ca_cert.arn

  consul_image = "public.ecr.aws/hashicorp/consul-enterprise:1.15.2-ent"
  consul_partition = "default"

  # for the network load balancer
  lb_enabled = true
  lb_subnets = aws_subnet.public.*.id
  lb_vpc_id = aws_vpc.main.id
}

# User Facing Client Service
resource "aws_ecs_service" "client" {
  name = "client"
  cluster = aws_ecs_cluster.main.arn
  task_definition = module.client.task_definition_arn
  desired_count = 1
  launch_type = "FARGATE"

  # this is only required if a service linked role for ECS isn't present in your account
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using-service-linked-roles.html
  # iam_role = aws_iam_role.service_linked_ecs_role.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.client_alb_targets.arn
    container_name = "client" # name from the above specified task definition's containers
    container_port = 9090
  }

  network_configuration {
    subnets = aws_subnet.private.*.id
    # defaults to the default VPC security group which allows all traffic from itself and all outbound traffic
    # instead, we define our own for each ECS service!
    security_groups = [aws_security_group.ecs_client_service.id, aws_security_group.consul_client.id]
    assign_public_ip = false
  }

  propagate_tags = "TASK_DEFINITION"
}