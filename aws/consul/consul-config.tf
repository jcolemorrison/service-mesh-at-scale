resource "consul_config_entry" "shipping_azure" {
  kind = "service-resolver"
  name = "shipping-azure"

  config_json = jsonencode({
    Redirect = {
      Service = "shipping"
      Peer = "azure-default"
    }
  })
}

resource "consul_config_entry" "loyalty" {
  kind = "service-resolver"
  name = "loyalty-gcp"

  config_json = jsonencode({
    Redirect = {
      Service = "loyalty"
      Peer = "gcp-default"
    }
  })
}

resource "consul_config_entry" "client_to_catalog" {
  kind = "service-intentions"
  name = "catalog"

  config_json = jsonencode({
    Sources = [{
      Name = "client"
      Action = "allow"
    }]
  })
}