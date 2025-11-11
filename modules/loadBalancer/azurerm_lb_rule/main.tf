data "azurerm_lb" "azurerm_lb_db" {
  for_each = var.lb_rule

  name                = each.value.lb_name
  resource_group_name = each.value.rg_name
}

data "azurerm_lb_backend_address_pool" "backend_ap_db" {
  for_each = var.lb_rule

  name            = each.value.backend_address_pool_db_ka_name
  loadbalancer_id = data.azurerm_lb.azurerm_lb_db[each.key].id
}




resource "azurerm_lb_rule" "lb_rule_rb" {
  for_each = var.lb_rule

  name                           = each.value.lb_rule_name
  loadbalancer_id                = data.azurerm_lb.azurerm_lb_db[each.key].id
  protocol                       = each.value.protocol # "Tcp"
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids = [
    data.azurerm_lb_backend_address_pool.backend_ap_db[each.key].id
  ]
  probe_id = var.lb_probe_ids[each.key]
}
