resource "azurerm_mssql_server" "sql_server" {
  for_each = var.sql_servers

  name                         = each.value.sqlservername
  resource_group_name          = each.value.rg_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.server_login_username
  administrator_login_password = each.value.server_login_password

  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", false)
}