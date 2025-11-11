variable "sql_databases" {
  description = "Map of SQL Databases with info about which server they belong to"
  type = map(object({
    name           = string
    server_name    = string
    resource_group = string
    sku_name       = string
    collation      = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    max_size_gb    = optional(number, 5)
    zone_redundant = optional(bool, false)
  }))
}
