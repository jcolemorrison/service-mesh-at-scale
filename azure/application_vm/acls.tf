provider "consul" {
  address    = var.consul_server_public_addr
  datacenter = var.datacenter
  token      = var.token
}

resource "consul_acl_policy" "service" {
  name        = "${var.service}-policy"
  rules       = <<-RULE
    node "${var.service}" {
      policy = "write"
    }

    agent "${var.service}" {
      policy = "write"
    }

    key_prefix "_rexec" {
      policy = "write"
    }

    service "${var.service}" {
    	policy = "write"
    }

    service "${var.service}-sidecar-proxy" {
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
  name = "${var.service}-role"
  description = "Role for the ${var.service} service"

  policies = [
      "${consul_acl_policy.service.id}"
  ]
}

resource "consul_acl_binding_rule" "service" {
    auth_method = var.auth_method
    description = "Rule to allow ${var.service} vm to login with azure jwt"
    selector    = "value.xms_mirid matches `.*/${var.service}`"
    bind_type   = "role"
    bind_name   = "${var.service}-role"
}