Kind      = "service-resolver"                                     ## required
Name      = "shipping-azure"
Namespace = "default" 
Partition = "default"

Redirect = {
 Service       = "shipping"
 Peer          = "azure-default"
}