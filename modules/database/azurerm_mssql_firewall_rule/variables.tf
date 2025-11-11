variable "firewall_rules" {
  type = map(object({
    server_id        = string
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

variable "sql_servers" {
  type = map(object({
    public_network_access_enabled = optional(bool, false)
  }))
}

variable "sql_servers_ids" {
  type = map(string)
}
