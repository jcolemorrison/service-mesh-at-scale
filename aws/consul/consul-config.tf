resource "consul_config_entry" "shipping_azure" {
  kind = "service-resolver"
  name = "shipping-azure"

  config_json = jsonencode({
    Redirect = {
      Service = "shipping"
      Peer    = "azure-default"
    }
  })
}

resource "consul_config_entry" "loyalty" {
  kind = "service-resolver"
  name = "loyalty-gcp"

  config_json = jsonencode({
    Redirect = {
      Service = "loyalty"
      Peer    = "gcp-default"
    }
  })
}

resource "consul_config_entry" "catalog" {
  kind      = "service-resolver"
  name      = "catalog" # name of service
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Redirect = {
      Service = "catalog"
      # Peer = "aws-catalog"
      Namespace = "default"
      Partition = "catalog"
    }
  })
}

resource "consul_config_entry" "catalog_intention" {
  kind      = "service-intentions"
  name      = "catalog"
  partition = "catalog"
  namespace = "default"

  config_json = jsonencode({
    Sources = [{
      Name = "client"
      # Peer = "aws-default"
      Action    = "allow"
      Partition = "default"
      Namespace = "default"
      }
    ]
  })
}

resource "consul_acl_policy" "catalog_partition" {
  name      = "catalog-partition-read"
  partition = "default"
  rules     = <<-RULE
    partition "catalog" {
      service_prefix "" {
        policy = "read"
      }

      node_prefix "" {
        policy = "read"
      }

      namespace_prefix "" {
        policy = "read"
      }
    }
  RULE
}

resource "consul_config_entry" "exported_catalog_services" {
  name      = "catalog"
  kind      = "exported-services"
  partition = "catalog"

  config_json = jsonencode({
    Services = [{
      Name      = "catalog"
      Namespace = "default"
      Consumers = [{
        Name      = "client"
        Partition = "default"
      }]
    }]
  })
}