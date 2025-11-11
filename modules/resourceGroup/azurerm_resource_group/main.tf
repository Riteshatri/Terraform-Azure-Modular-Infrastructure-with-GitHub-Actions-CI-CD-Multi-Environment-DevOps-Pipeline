resource "azurerm_resource_group" "resource_group_rb" {
  name     = var.rg_name
  location = var.location
}