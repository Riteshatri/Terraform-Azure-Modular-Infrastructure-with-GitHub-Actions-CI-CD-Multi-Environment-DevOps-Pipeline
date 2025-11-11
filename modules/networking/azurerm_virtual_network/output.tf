output "virtual_networks" {
  value = {
    for vnet_key, vnet in azurerm_virtual_network.virtual_network_rb :
    vnet_key => {
      vnet_name = vnet.name
      location  = vnet.location
      subnets   = try([for s in vnet.subnet : s.name], [])
    }
  }
}


output "vnet_subnet_ids" {
  value = {
    for vnet_key, vnet in azurerm_virtual_network.virtual_network_rb :
    vnet.name => (
      can(vnet.subnet) ? {
        for subnet in vnet.subnet :
        subnet.name => subnet.id
      } : {}
    )
  }
}
