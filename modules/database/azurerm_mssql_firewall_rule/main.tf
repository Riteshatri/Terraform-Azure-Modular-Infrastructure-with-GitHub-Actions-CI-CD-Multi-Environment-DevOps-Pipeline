resource "azurerm_mssql_firewall_rule" "firewall_rules" {
  for_each = {
    for rule_key, rule_val in var.firewall_rules :
    rule_key => rule_val
    if lookup(var.sql_servers, rule_val.server_id, { public_network_access_enabled = false }).public_network_access_enabled == true
  }

  name             = each.value.name
  server_id        = var.sql_servers_ids[each.value.server_id]
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
