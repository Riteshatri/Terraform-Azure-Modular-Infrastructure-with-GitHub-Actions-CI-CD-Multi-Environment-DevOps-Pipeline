output "nsg_ids" {
  description = "IDs of all created Network Security Groups"
  value = {
    for key, nsg in azurerm_network_security_group.nsg :
    key => nsg.id
  }
}

output "nsg_names" {
  description = "Names of all created Network Security Groups"
  value = {
    for key, nsg in azurerm_network_security_group.nsg :
    key => nsg.name
  }
}