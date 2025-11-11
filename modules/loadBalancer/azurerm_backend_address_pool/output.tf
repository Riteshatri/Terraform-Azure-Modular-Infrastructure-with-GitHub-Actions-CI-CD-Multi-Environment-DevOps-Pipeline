output "backend_address_pool_ids" {
  value = {
    for k, pool in azurerm_lb_backend_address_pool.backend_ap_rb :
    k => pool.id
  }
}
