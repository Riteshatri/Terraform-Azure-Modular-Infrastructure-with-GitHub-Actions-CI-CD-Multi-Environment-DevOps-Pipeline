data "azurerm_network_interface" "nic_ids_db" {
  for_each            = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}


resource "azurerm_linux_virtual_machine" "rit-vm" {
  for_each = var.vms

  name                = each.value.vm_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password

  disable_password_authentication = false

  network_interface_ids = [data.azurerm_network_interface.nic_ids_db[each.key].id]

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = each.value.vm_publisher
    offer     = each.value.vm_offer
    sku       = each.value.vm_sku
    version   = each.value.vm_version
  }

  custom_data = lookup(each.value, "custom_data", null) != null ? base64encode(each.value.custom_data) : null

  # lifecycle {
  #   prevent_destroy = true
  # }
  
}
