# resource "consul_config_entry" "exported_services" {
#   name = "default"
#   kind = "exported-services"

#   config_json = jsonencode({
#     Services = [
#     {
#       Name = "tea-catalog"
#       Consumers = [{
#         Peer = "${var.peer_datacenter}-${var.peer_partition}" # aws-default
#       },{
#           Peer = "gcp-${var.peer_partition}" # gcp-default
#       }]
#     },
#     {
#       Name = "tea-customers"
#       Consumers = [{
#         Peer = "${var.peer_datacenter}-${var.peer_partition}"
#       },{
#         Peer = "gcp-${var.peer_partition}"
#       }]
#     },
#     {
#       Name = "shipping"
#       Consumers = [{
#         Peer = "${var.peer_datacenter}-${var.peer_partition}"
#       },
#       {
#         Peer = "gcp-${var.peer_partition}"
#       }]
#     }
#     ]
#   })
# }

# resource "consul_config_entry" "shipping_intention" {
#   name = "shipping"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [{
#       Name = "orders"
#       Peer = "aws-default"
#       Action = "allow"
#     }]
#   })
# }

# resource "consul_config_entry" "tea_catalog_intention" {
#   name = "tea-catalog"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [{
#       Name = "catalog"
#       Peer = "aws-default"
#       Action = "allow"
#     }]
#   })
# }

# resource "consul_config_entry" "tea_customers_intention" {
#   name = "tea-customers"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [{
#       Name = "customers"
#       Peer = "aws-default"
#       Action = "allow"
#     }]
#   })
# }