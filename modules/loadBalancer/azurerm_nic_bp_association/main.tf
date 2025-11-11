data "azurerm_network_interface" "nic_db" {
  for_each = var.nic_bp_association

  name                = each.value.nic_name
  resource_group_name = each.value.nic_rg_name
}

data "azurerm_lb" "azurerm_lb_db" {
  for_each = var.nic_bp_association

  name                = each.value.lb_name
  resource_group_name = each.value.rg_name
}

data "azurerm_lb_backend_address_pool" "backend_address_pool_db" {
  for_each = var.nic_bp_association

  name            = each.value.backend_address_pool_name
  loadbalancer_id = data.azurerm_lb.azurerm_lb_db[each.key].id

}

resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_assoc" {
  for_each = var.nic_bp_association

  network_interface_id    = data.azurerm_network_interface.nic_db[each.key].id
  ip_configuration_name   = each.value.nic_ka_ip_config_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.backend_address_pool_db[each.key].id
}
