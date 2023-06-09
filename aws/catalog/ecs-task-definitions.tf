module "catalog" {
  source            = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version           = "0.6.0"

  family = "catalog"

  # required for Fargate launch type
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512

  container_definitions = [
    {
      name = "catalog"
      image = "ghcr.io/nicholasjackson/fake-service:v0.25.2"
      cpu = 0 # take up proportional cpu
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort = 9090 # though, access to the ephemeral port range is needed to connect on EC2, the exact port is required on Fargate from a security group standpoint.
          protocol = "tcp"
        }
      ]

      logConfiguration = local.catalog_logs_configuration

      # Fake Service settings are set via Environment variables
      environment = [
        {
          name = "NAME" # Fake Service name
          value = "catalog" 
        },
        {
          name = "MESSAGE" # Fake Service message to return
          value = "Hello from the catalog"
        },
        {
          name = "UPSTREAM_URIS" # Fake service upstream service to call to
          value = "http://localhost:1234" # point all upstreams to the proxy
        }
      ]
    }
  ]

  upstreams = [
    {
      destinationName = "coffee-catalog"
      localBindPort = 1234
        meshGateway = {
          mode = "local"
        }
    }
  ]

  # All settings required by the mesh-task module
  acls = true
  # enable_acl_token_replication = true
  consul_http_addr             = "${data.hcp_consul_cluster.aws.consul_private_endpoint_url}"

  consul_datacenter = data.hcp_consul_cluster.aws.datacenter
  consul_primary_datacenter = data.hcp_consul_cluster.aws.datacenter # required for mesh gateways?

  # really not sure how this is different from consul_server_ca_cert_arn...
  # consul_https_ca_cert_arn = aws_secretsmanager_secret.consul_root_ca_cert.arn # apparently not required on HCP
  consul_server_ca_cert_arn = aws_secretsmanager_secret.consul_root_ca_cert.arn

  gossip_key_secret_arn = aws_secretsmanager_secret.consul_gossip_key.arn

  log_configuration = local.catalog_sidecars_log_configuration
  
  # https://github.com/hashicorp/consul-ecs/blob/main/config/schema.json#L74#
  # to tell the proxy and consul-ecs how to contact the service
  port = "9090" 
  tls = true

  # DNS to join consul on
  retry_join = jsondecode(base64decode(data.hcp_consul_cluster.aws.consul_config_file))["retry_join"]

  # Admin Partitions
  consul_partition = "catalog"
  consul_namespace = "default"
  consul_image = "public.ecr.aws/hashicorp/consul-enterprise:1.15.2-ent"

  # not 100 if this is required, but it's present in the other ecs tasks and services
  additional_task_role_policies = [aws_iam_policy.execute_command.arn]

  depends_on = [
    module.consul_acl_controller
  ]
}