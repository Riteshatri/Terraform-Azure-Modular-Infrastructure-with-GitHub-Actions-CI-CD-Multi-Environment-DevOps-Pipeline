variable "lb_rule" {
  type = map(object({
    lb_name                         = string
    rg_name                         = string
    backend_address_pool_db_ka_name = string
    lb_rule_name                    = string
    protocol                        = string
    frontend_port                   = number
    backend_port                    = number
    frontend_ip_configuration_name  = string
    probe_name                      = string
  }))
}

variable "lb_probe_ids" {
  type = map(string)
}
