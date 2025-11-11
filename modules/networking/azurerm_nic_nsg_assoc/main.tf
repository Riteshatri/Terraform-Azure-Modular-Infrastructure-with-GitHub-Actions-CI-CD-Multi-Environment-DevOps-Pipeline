data "azurerm_network_interface" "nic_ids_db" {
  for_each            = var.nic_nsg_ids
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

data "azurerm_network_security_group" "nsg_ids_db" {
  for_each            = var.nic_nsg_ids
  name                = each.value.nsg_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  for_each                  = var.nic_nsg_ids
  network_interface_id      = data.azurerm_network_interface.nic_ids_db[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg_ids_db[each.key].id
 
  #  lifecycle {
  #   prevent_destroy = true
  # }
}
