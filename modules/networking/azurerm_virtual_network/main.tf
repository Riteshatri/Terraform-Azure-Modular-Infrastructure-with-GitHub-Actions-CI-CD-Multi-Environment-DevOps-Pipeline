resource "azurerm_virtual_network" "virtual_network_rb" {
  for_each   = var.vnets

  name                = each.value.vnet_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.address_space

  dynamic "subnet" {
    for_each = contains(keys(each.value), "subnets") && each.value.subnets != null ? each.value.subnets : {}

    content {
      name             = subnet.value.subnet_name
      address_prefixes = subnet.value.subnet_address_prefixes
    }
  }
}
