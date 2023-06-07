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

resource "consul_config_entry" "exported_services_azure" {
  kind = "exported-services"
  name = "azure-client"
  partition = "default"

  config_json = jsonencode({
    Services = [
      {
        Name      = "service-mesh-client-client"
        Namespace = "default"
        Consumers = [
            {
                Peer  = "azure-default"
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