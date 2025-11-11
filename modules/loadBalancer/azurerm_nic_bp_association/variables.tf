variable "nic_bp_association" {
  type = map(object({

      nic_name       = string
      nic_rg_name    = string

      lb_name = string
      rg_name    = string

      backend_address_pool_name = string
      
      nic_ka_ip_config_name = string
      
    }))
}
