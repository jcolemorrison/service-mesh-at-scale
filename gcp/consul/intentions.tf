resource "consul_config_entry" "service_intentions_customers" {
  name = "customers"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "customers"
        Precedence = 9
        Type       = "consul"
        Peer       = "aws"
      }
    ]
  })
}

resource "consul_config_entry" "service_intentions_catalog" {
  name = "catalog"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "catalog"
        Precedence = 9
        Type       = "consul"
        Peer       = "aws"
      }
    ]
  })
}

resource "consul_config_entry" "service_intentions_loyalty" {
  name = "loyalty"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "ui"
        Precedence = 9
        Type       = "consul"
        Peer       = "aws"
      }
    ]
  })
}