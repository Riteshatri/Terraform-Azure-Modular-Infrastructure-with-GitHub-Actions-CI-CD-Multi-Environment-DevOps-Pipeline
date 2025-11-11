variable "vms" {
  description = "A map of virtual machine configurations"
  type = map(object({
    vm_name                      = string
    rg_name                      = string
    location                     = string
    vm_size                      = string
    admin_username               = string
    admin_password               = string
    nic_name                     = string
    os_disk_caching              = string
    os_disk_storage_account_type = string
    vm_publisher                 = string
    vm_offer                     = string
    vm_sku                       = string
    vm_version                   = string
    custom_data                  = optional(string)
  }))
}
