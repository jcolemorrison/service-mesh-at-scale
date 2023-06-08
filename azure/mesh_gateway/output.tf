output "public_ip" {
    value = azurerm_public_ip.service.ip_address
}