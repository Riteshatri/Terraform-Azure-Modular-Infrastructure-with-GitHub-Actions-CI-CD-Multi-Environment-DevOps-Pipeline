module "rg_module" {
  for_each = var.resource_groups

  source   = "../modules/resourceGroup/azurerm_resource_group"
  rg_name  = each.value.name
  location = each.value.location
}

module "vnet_module" {
  source     = "../modules/networking/azurerm_virtual_network"
  depends_on = [module.rg_module]
  vnets      = var.vnets
}

module "nsg_module" {
  source     = "../modules/networking/azurerm_nsg"
  depends_on = [module.rg_module]
  nsg        = var.nsg
}


module "nic_module" {
  source     = "../modules/networking/azurerm_nic"
  depends_on = [module.rg_module, module.vnet_module, module.nsg_module, module.pip_module]
  nics       = var.nics
  pip_ids    = module.pip_module.pip_ids

}

module "pip_module" {
  source     = "../modules/networking/azurerm_pip"
  depends_on = [module.rg_module]
  pips       = var.pips
}

module "bastion_module" {
  source     = "../modules/networking/azurerm_bastion"
  depends_on = [module.rg_module, module.vnet_module, module.pip_module]
  bastion    = var.bastion
}

module "nic_nsg_assoc_module" {
  source      = "../modules/networking/azurerm_nic_nsg_assoc"
  depends_on  = [module.nic_module, module.nsg_module]
  nic_nsg_ids = var.nic_nsg_ids
}

module "vm_module" {
  source = "../modules/virtual_machine"

  depends_on = [module.rg_module, module.nic_module]
  vms        = var.vms
}


module "sql_server" {
  depends_on  = [module.rg_module]
  source      = "../modules/database/azurerm_mssql_server"
  sql_servers = var.sql_servers
}

module "firewall_rule" {
  depends_on      = [module.sql_server]
  source          = "../modules/database/azurerm_mssql_firewall_rule"
  firewall_rules  = var.firewall_rules
  sql_servers     = var.sql_servers
  sql_servers_ids = module.sql_server.sql_servers_ids
}

module "database" {
  depends_on    = [module.sql_server, module.firewall_rule]
  source        = "../modules/database/azurerm_mssql_database"
  sql_databases = var.sql_databases
}


module "loadbalancer" {
  source        = "../modules/loadBalancer/azurerm_lb"
  depends_on    = [module.rg_module, module.pip_module]
  azurerm_lb_rb = var.azurerm_lb_rb
}

module "backendaddresspool" {
  source        = "../modules/loadBalancer/azurerm_backend_address_pool"
  depends_on    = [module.loadbalancer]
  backend_ap_rb = var.backend_ap_rb
}

module "nic_bp_association" {
  source             = "../modules/loadBalancer/azurerm_nic_bp_association"
  depends_on         = [module.backendaddresspool , module.nic_nsg_assoc_module , module.nic_module ]
  nic_bp_association = var.nic_bp_association
}

module "lb_health_probe" {
  source     = "../modules/loadBalancer/azurerm_lb_probe"
  depends_on = [module.nic_bp_association]
  lb_probe   = var.lb_probe
}

module "lb_rule" {
  source       = "../modules/loadBalancer/azurerm_lb_rule"
  depends_on   = [module.lb_health_probe, module.nic_bp_association]
  lb_rule      = var.lb_rule
  lb_probe_ids = module.lb_health_probe.lb_probe_ids
}
