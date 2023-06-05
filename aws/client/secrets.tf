resource "aws_secretsmanager_secret" "consul_gossip_key" {
  name_prefix = "${local.project_tag}-gossip-key-"
}

resource "aws_secretsmanager_secret_version" "consul_gossip_key" {
  secret_id     = aws_secretsmanager_secret.consul_gossip_key.id
  secret_string = jsondecode(base64decode(data.hcp_consul_cluster.smas.consul_config_file))["encrypt"]
}

resource "aws_secretsmanager_secret" "consul_bootstrap_token" {
  name_prefix = "${local.project_tag}-bootstrap-token-"
}

resource "aws_secretsmanager_secret_version" "consul_bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.consul_bootstrap_token.id
  secret_string = data.hcp_consul_cluster.smas.consul_root_token_secret_id
}

resource "aws_secretsmanager_secret" "consul_root_ca_cert" {
  name_prefix = "${local.project_tag}-root-ca-cert-"
}

resource "aws_secretsmanager_secret_version" "consul_root_ca_cert" {
  secret_id     = aws_secretsmanager_secret.consul_root_ca_cert.id
  secret_string = base64decode(data.hcp_consul_cluster.smas.consul_ca_file)
}