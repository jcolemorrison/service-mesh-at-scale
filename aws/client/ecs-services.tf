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
  consul_server_ca_cert_arn         = aws_secretsmanager_secret.consul_root_ca_cert.arn
  consul_server_http_addr = "https://${data.hcp_consul_cluster.smas.consul_private_endpoint_url}:8501"

  # the ACL controller module creates the required IAM role to allow logging
  log_configuration = local.acl_logs_configuration

  depends_on = [
    aws_nat_gateway.nat,
  ]
}

# User Facing Client Service
resource "aws_ecs_service" "client" {
  name = "${local.project_tag}-client"
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