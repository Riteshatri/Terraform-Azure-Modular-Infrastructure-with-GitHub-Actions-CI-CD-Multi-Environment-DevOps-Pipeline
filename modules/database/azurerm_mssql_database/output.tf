output "sql_database_ids" {
  value = {
    for db_key, db in azurerm_mssql_database.database :
    db_key => db.id
  }
}
