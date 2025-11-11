output "bastion_hosts" {
  description = "Map of Bastion Host names to their IDs"
  value = {
    for key, bastion in azurerm_bastion_host.bastion :
    key => {
      name = bastion.name
      id   = bastion.id
      location = bastion.location
    }
  }
}
