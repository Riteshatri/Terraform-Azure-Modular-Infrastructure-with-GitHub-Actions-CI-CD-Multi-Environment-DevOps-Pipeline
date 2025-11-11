

output "load_balancer_public_ips" {
  value = {
    for lb_key, lb_val in azurerm_lb.azurerm_lb_rb :
    lb_key => {
      lb_name = lb_val.name
      public_ip = data.azurerm_public_ip.lb_pip_db[lb_key].ip_address
    }
  }
}
