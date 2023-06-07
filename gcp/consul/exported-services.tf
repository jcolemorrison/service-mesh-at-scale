resource "consul_config_entry" "exported_services" {
  name = "default"
  kind = "exported-services"

  config_json = jsonencode({
    Services = [{
      Name = "catalog"
      Consumers = [{
        Peer = "aws-client"
      }]
      },
      {
        Name = "customers"
        Consumers = [{
          Peer = "aws-client"
        }]
      },
      {
        Name = "loyalty"
        Consumers = [{
          Peer = "aws-client"
        }]
    }]
  })
}