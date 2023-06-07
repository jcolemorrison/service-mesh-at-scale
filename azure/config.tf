resource "consul_config_entry" "exported_services" {
  name = "default"
  kind = "exported-services"

  config_json = jsonencode({
    Services = [{
      Name = "tea-catalog"
      Consumers = [{
        Peer = "${var.peer_datacenter}-${var.peer_partition}"
      }]
      },
      {
        Name = "tea-customers"
        Consumers = [{
          Peer = "${var.peer_datacenter}-${var.peer_partition}"
        }]
      },
      {
        Name = "shipping"
        Consumers = [{
          Peer = "${var.peer_datacenter}-${var.peer_partition}"
        }]
    }]
  })
}