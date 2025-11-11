output "sql_servers_ids" {
  value = { for k, v in azurerm_mssql_server.sql_server : k => v.id }
}
