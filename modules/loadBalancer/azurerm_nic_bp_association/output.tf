output "nic_backend_associations" {
  value = {
    for k, assoc in azurerm_network_interface_backend_address_pool_association.nic_backend_assoc :
    k => {
      nic_id                  = assoc.network_interface_id
      backend_address_pool_id = assoc.backend_address_pool_id
    }
  }
}
