# resource "consul_config_entry" "service_intentions_loyalty" {
#   name = "loyalty"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [
#       {
#         Action     = "allow"
#         Name       = "client"
#         Peer       = "aws-default"
#         Precedence = 9
#         Type       = "consul"
#       }
#     ]
#   })
# }

# resource "consul_config_entry" "service_intentions_coffee_catalog" {
#   name = "coffee-catalog"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [
#       {
#         Action     = "allow"
#         Name       = "catalog"
#         Peer       = "aws-default"
#         Precedence = 9
#         Type       = "consul"
#       }
#     ]
#   })
# }

# resource "consul_config_entry" "service_intentions_coffee_customers" {
#   name = "coffee-customers"
#   kind = "service-intentions"

#   config_json = jsonencode({
#     Sources = [
#       {
#         Action     = "allow"
#         Name       = "customers"
#         Peer       = "aws-default"
#         Precedence = 9
#         Type       = "consul"
#       }
#     ]
#   })
# }