Kind      = "service-resolver"                                     ## required
Name      = "test"
Namespace = "default" 
Partition = "default"

Redirect = {
 Service       = "shipping"
 Peer          = "azure-default"
}