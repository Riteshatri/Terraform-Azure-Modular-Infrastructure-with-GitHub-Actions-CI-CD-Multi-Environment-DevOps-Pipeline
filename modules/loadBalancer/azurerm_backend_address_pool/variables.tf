variable "backend_ap_rb" {
  type = map(object({
    rg_name  = string
    lb_name  = string
    backend_pool_name = string
  }))
}
