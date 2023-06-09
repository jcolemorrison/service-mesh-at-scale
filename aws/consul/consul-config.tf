# Note, the service-resolvers exist to bypass the fact that consul-ecs doesn't support a destinationPeer option

# Azure Service Resolvers
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

resource "consul_config_entry" "tea_catalog" {
  kind = "service-resolver"
  name = "tea-catalog"

  config_json = jsonencode({
    Redirect = {
      Service = "tea-catalog"
      Peer = "azure-default"
    }
  })
}

resource "consul_config_entry" "tea_customers" {
  kind = "service-resolver"
  name = "tea-customers"

  config_json = jsonencode({
    Redirect = {
      Service = "tea-customers"
      Peer = "azure-default"
    }
  })
}


# GCP Service Resolvers
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

resource "consul_config_entry" "coffee_catalog" {
  kind = "service-resolver"
  name = "coffee-catalog"

  config_json = jsonencode({
    Redirect = {
      Service = "coffee-catalog"
      Peer = "gcp-default"
    }
  })
}

resource "consul_config_entry" "coffee_customers" {
  kind = "service-resolver"
  name = "coffee-customers"

  config_json = jsonencode({
    Redirect = {
      Service = "coffee-customers"
      Peer = "gcp-default"
    }
  })
}


# AWS Local Intentions
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

resource "consul_config_entry" "client_to_customers" {
  kind = "service-intentions"
  name = "customers"

  config_json = jsonencode({
    Sources = [{
      Name = "client"
      Action = "allow"
    }]
  })
}

resource "consul_config_entry" "client_to_orders" {
  kind = "service-intentions"
  name = "orders"

  config_json = jsonencode({
    Sources = [{
      Name = "client"
      Action = "allow"
    }]
  })
}