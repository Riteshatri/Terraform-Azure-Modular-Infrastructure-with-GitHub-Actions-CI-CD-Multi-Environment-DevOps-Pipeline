# Variable for SQL Servers
variable "sql_servers" {
  description = "Map of SQL Server configurations"
  type = map(object({
    sqlservername                 = string
    rg_name                       = string
    location                      = string
    version                       = string
    server_login_username         = string
    server_login_password         = string
    public_network_access_enabled = optional(bool, false)
  }))
}