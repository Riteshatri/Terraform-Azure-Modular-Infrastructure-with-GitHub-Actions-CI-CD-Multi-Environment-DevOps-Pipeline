variable "bastion" {
  type = map(object({
    bastion_name = string
    location     = string
    rg_name      = string
    vnet_name    = string
    subnet_name  = string
    pip_name     = string
    
    ip_configuration = object({
      name                 = string
    })
  }))
}