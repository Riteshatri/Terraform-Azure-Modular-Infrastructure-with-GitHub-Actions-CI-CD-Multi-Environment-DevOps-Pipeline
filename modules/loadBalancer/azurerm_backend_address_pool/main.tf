data "azurerm_lb" "azurerm_lb_db" {
  for_each = var.backend_ap_rb

  name                = each.value.lb_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_lb_backend_address_pool" "backend_ap_rb" {
  for_each = var.backend_ap_rb

  name            = each.value.backend_pool_name
  loadbalancer_id = data.azurerm_lb.azurerm_lb_db[each.key].id
}
