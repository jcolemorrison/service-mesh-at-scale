# resource "consul_config_entry" "exported_services" {
#   name = "default"
#   kind = "exported-services"

#   config_json = jsonencode({
#     Services = [{
#       Name = "tea-catalog"
#       Consumers = [{
#         Peer = "${var.peer_datacenter}-${var.peer_partition}"
#       },{
#         Peer = "gcp-${var.peer_partition}"
#       }
#       ]
#       },
#       {
#         Name = "tea-customers"
#         Consumers = [{
#           Peer = "${var.peer_datacenter}-${var.peer_partition}"
#         },{
#           Peer = "gcp-${var.peer_partition}"
#         }
#       ]
#       },
#       {
#         Name = "shipping"
#         Consumers = [{
#           Peer = "${var.peer_datacenter}-${var.peer_partition}"
#         },
#         {
#           Peer = "gcp-${var.peer_partition}"
#         }
#         ]
#     }]
#   })
# }

resource "consul_config_entry" "exported_services" {
  kind = "exported-services"
  partition = "default"
  name = "default"

  config_json = jsonencode({
    Services = [{
      Name = "tea-catalog"
      Namespace = "default"
      Consumers = [{
        Partition = "${var.peer_partition}"
      }
      ]
      },
      {
        Name = "tea-customers"
        Namespace = "default"
        Consumers = [{
          Partition = "${var.peer_partition}"
        }
      ]
      },
      {
        Name = "shipping"
        Namespace = "default"
        Consumers = [{
          Partition = "${var.peer_partition}"
        }
        ]
    }]
  })
}

resource "consul_config_entry" "loyalty_intention" {
  name = "shipping"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
    Name = "loyalty"
    Peer = "gcp"
    Action = "allow"
    }]
  })
}