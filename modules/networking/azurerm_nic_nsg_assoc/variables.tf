variable nic_nsg_ids {
  description = "A map of objects containing NIC and NSG names along with their resource group names."
  type = map(object({
    nic_name = string
    nsg_name = string
    rg_name  = string
  }))
}