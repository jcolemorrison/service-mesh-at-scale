resource "consul_config_entry" "exported_services" {
  Kind = "exported-services"
  Name = "default"

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
