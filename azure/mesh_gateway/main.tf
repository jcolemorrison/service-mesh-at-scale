resource "azurerm_public_ip" "service" {
  name                = "gateway"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "service" {
  name                = "gateway"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.service.id
  }
}


resource "azurerm_network_security_rule" "allow_gateway" {
  name                        = "gateway-https"
  priority                    = 223
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefixes     = ["0.0.0.0/0"]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = var.network_security_group_name
}

data "template_file" "service" {
  template = file("${path.module}/templates/service.tpl")
  vars = {
    datacenter                 = var.datacenter
    consul_server_private_addr = trimprefix(var.consul_server_private_addr, "https://")
    consul_ca                  = var.consul_ca
    gossip_encryption_key      = var.gossip_encryption_key
    vm_public_ip               = azurerm_public_ip.service.ip_address
  }
}

resource "azurerm_user_assigned_identity" "service" {
  resource_group_name = var.resource_group
  location            = var.location

  name = "gateway"
}

resource "random_password" "server" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_id" "disk" {
  byte_length = 8
}

resource "azurerm_virtual_machine" "service" {
  name                  = "gateway"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = ["${azurerm_network_interface.service.id}"]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.service.id]
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = random_id.disk.hex
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "payment"
    admin_username = "ubuntu"
    admin_password = random_password.server.result
    custom_data = data.template_file.service.rendered 
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = var.ssh_key
      path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}