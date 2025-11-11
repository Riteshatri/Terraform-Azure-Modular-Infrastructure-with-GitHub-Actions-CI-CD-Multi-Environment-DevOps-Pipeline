output "nic_ids" {
  description = "IDs of the network interfaces created"
  value = {
    for key, nic in azurerm_network_interface.nic :
    key => nic.id
  }
}

output "nic_names" {
  description = "Names of the network interfaces created"
  value = {
    for key, nic in azurerm_network_interface.nic :
    key => nic.name
  }
}

output "nic_private_ips" {
  description = "Private IPs from the NICs (first ip_configuration only)"
  value = {
    for key, nic in azurerm_network_interface.nic :
    key => try(nic.ip_configuration[0].private_ip_address, null)
  }
}

output "nic_configs" {
  description = "All IP configurations from each NIC"
  value = {
    for key, nic in azurerm_network_interface.nic :
    key => nic.ip_configuration
  }
}


output "nic_ip_configs" {
  value = {
    for k, nic in azurerm_network_interface.nic : k => nic.ip_configuration
  }
}
