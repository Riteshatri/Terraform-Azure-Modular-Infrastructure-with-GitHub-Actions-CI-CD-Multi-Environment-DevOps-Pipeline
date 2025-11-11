locals {
  unique_sql_servers = {
    for server in distinct([
      for db in var.sql_databases : {
        server_name = db.server_name
        rg_name     = db.resource_group
      }
    ]) : server.server_name => server.rg_name
  }
}

data "azurerm_mssql_server" "db_server" {
  for_each = local.unique_sql_servers

  name                = each.key
  resource_group_name = each.value
}

resource "azurerm_mssql_database" "database" {
  for_each = var.sql_databases

  name           = each.value.name
  server_id      = data.azurerm_mssql_server.db_server[each.value.server_name].id
  collation      = lookup(each.value, "collation", "SQL_Latin1_General_CP1_CI_AS")
  sku_name       = each.value.sku_name
  max_size_gb    = lookup(each.value, "max_size_gb", 5)
  zone_redundant = lookup(each.value, "zone_redundant", false)
}


# # Data block to fetch SQL Server IDs by name & RG
# data "azurerm_mssql_server" "db_server" {
#   for_each = {
#     for db_key, db_value in var.sql_databases :
#     db_value.server_name => {
#       rg   = db_value.resource_group
#       name = db_value.server_name
#     }
#   }

#   name                = each.value.name
#   resource_group_name = each.value.rg
# }

# # MSSQL Database resource creation
# resource "azurerm_mssql_database" "this" {
#   for_each = var.sql_databases

#   name           = each.value.name
#   server_id      = data.azurerm_mssql_server.db_server[each.value.server_name].id
#   collation      = lookup(each.value, "collation", "SQL_Latin1_General_CP1_CI_AS")
#   sku_name       = each.value.sku_name
#   max_size_gb    = lookup(each.value, "max_size_gb", 5)
#   zone_redundant = lookup(each.value, "zone_redundant", false)
# }
