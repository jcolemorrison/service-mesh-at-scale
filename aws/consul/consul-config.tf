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

resource "consul_config_entry" "shipping_azure" {
  kind = "service-resolver"
  name = "shipping-azure"

  config_json = jsonencode({
    Redirect = {
      Service = "shipping"
      Peer = "azure"
    }
  })
}