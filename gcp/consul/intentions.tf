resource "consul_config_entry" "service_intentions_loyalty" {
  name = "loyalty"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "client"
        Peer       = "aws-default"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}