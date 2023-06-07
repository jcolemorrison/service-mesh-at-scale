resource "consul_config_entry" "exported_services" {
  kind = "exported-services"
  name = "default"

  config_json = jsonencode({
    Services = [
      {
        Name      = "client"
        Consumers = [
            {
                Peer  = "gcp-default"
            },
        ]
      }
    ] 
  })
}
