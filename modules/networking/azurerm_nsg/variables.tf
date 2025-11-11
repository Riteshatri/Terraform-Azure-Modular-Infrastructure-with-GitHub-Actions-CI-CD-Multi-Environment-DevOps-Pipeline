variable "nsg" {
  description = "List of security rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_name  = string
    security_rules = optional(map(object({
      security_rule_name         = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })))
  }))
}
