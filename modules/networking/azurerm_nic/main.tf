data "azurerm_subnet" "subnetdb" {
  for_each             = var.nics
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_network_interface" "nic" {
  for_each = var.nics

  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name      = ip_configuration.value.ip_config_name
      subnet_id = data.azurerm_subnet.subnetdb[each.key].id

      private_ip_address_allocation = ip_configuration.value.private_ip_allocation
      private_ip_address            = ip_configuration.value.private_ip_allocation == "Static" ? ip_configuration.value.private_ip_address : null

      public_ip_address_id = (
        try(ip_configuration.value.public_ip_name, null) != null &&
        contains(keys(var.pip_ids), ip_configuration.value.public_ip_name)
      ) ? var.pip_ids[ip_configuration.value.public_ip_name] : null

      primary = try(ip_configuration.value.primary, false)
    }
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}
