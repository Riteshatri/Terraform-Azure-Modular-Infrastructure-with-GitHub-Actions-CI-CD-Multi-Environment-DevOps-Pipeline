data "azurerm_public_ip" "pip" {
  for_each            = var.bastion
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
}
data "azurerm_subnet" "subnet_db" {
  for_each             = var.bastion
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}


resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bastion
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                 = each.value.ip_configuration.name
    subnet_id            = data.azurerm_subnet.subnet_db[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}
