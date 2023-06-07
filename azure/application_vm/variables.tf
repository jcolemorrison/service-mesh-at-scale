variable "ssh_key" {
  description = "SSH key to log into the server"
}

variable "service" {
  description = "Service name"
}

variable "location" {
  description = "Location for the vm"
}

variable "resource_group" {
  description = "Resource group for the vm"
}

variable "consul_server_private_addr" {
  description = "Private address of the consul server to join"
}

variable "consul_server_public_addr" {
  description = "Public address of the consul server, used for configuring acls"
}

variable "consul_ca" {
  description = "CA for the consul server"
}

variable "datacenter" {
  description = "Consul server datacenter"
}

variable "token" {
  description = "Consul server token used for configuring acls"
}

variable "auth_method" {
  description = "Consul server auth method"
}

variable "subnet_id" {
  description = "id of the network subnet"
}

variable "network_security_group_name" {
  description = "name of the network security group"
}

variable "gossip_encryption_key" {
  description = "gossip encryption key for consul"
}