resource "consul_config_entry" "exported_services" {
  name = "default"
  kind = "exported-services"

  config_json = jsonencode({
    Services = [{
      Name = "catalog"
      Consumers = [{
        Peer      = var.peer_datacenter
        Partition = var.peer_partition
      }]
      },
      {
        Name = "customers"
        Consumers = [{
          Peer      = var.peer_datacenter
          Partition = var.peer_partition
        }]
      },
      {
        Name = "loyalty"
        Consumers = [{
          Peer      = var.peer_datacenter
          Partition = var.peer_partition
        }]
    }]
  })
}