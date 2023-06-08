provider "consul" {
  address    = var.consul_server_public_addr
  datacenter = var.datacenter
  token      = var.token
}

resource "consul_acl_policy" "service" {
  name        = "gateway-policy"
  rules       = <<-RULE
    node "gateway" {
      policy = "write"
    }

    agent "gateway" {
      policy = "write"
    }

    key_prefix "_rexec" {
      policy = "write"
    }

    service_prefix "mesh-gateway" {
    	policy = "write"
    }

    service_prefix "" {
    	policy = "read"
    }

    node_prefix "" {
    	policy = "read"
    }
  RULE
}

resource "consul_acl_role" "service" {
  name = "gateway-role"
  description = "Role for mesh gateways"

  policies = [
      "${consul_acl_policy.service.id}"
  ]
}

resource "consul_acl_binding_rule" "service" {
    auth_method = var.auth_method
    description = "Rule to allow gateway to login with azure jwt"
    selector    = "value.xms_mirid matches `.*/gateway`"
    bind_type   = "role"
    bind_name   = "gateway-role"
}