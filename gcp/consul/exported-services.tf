resource "consul_config_entry" "exported_services" {
  name = "default"
  kind = "exported-services"

  config_json = jsonencode({
    Services = [{
      Name = "coffee-catalog"
      Consumers = [{
        Peer = "${var.peer_datacenter}-${var.peer_partition}" # aws-default
      }]
      },
      {
        Name = "coffee-customers"
        Consumers = [{
          Peer = "${var.peer_datacenter}-${var.peer_partition}"
        }]
      },
      {
        Name = "loyalty"
        Consumers = [{
          Peer = "${var.peer_datacenter}-${var.peer_partition}"
        }]
    }]
  })
}