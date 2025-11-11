output "resource_group_ob_names" {
  value = {
    for key, rg in module.rg_module :
    key => rg.rg_name1
  }
}

output "resource_group_ob_locations" {
  value = {
    for key, rg in module.rg_module :
    key => rg.location1
  }
}

output "resource_group_ob_ids" {
  value = {
    for key, rg in module.rg_module :
    key => rg.id1
  }
}
#############
##############
#################

output "virtual_networks" {
  value = module.vnet_module.virtual_networks
}

output "vnet_subnet_ids" {
  value = module.vnet_module.vnet_subnet_ids
}

output "lb_probe_ids" {
  value = module.lb_health_probe.lb_probe_ids
}
