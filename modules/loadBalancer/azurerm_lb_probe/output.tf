output "lb_probes" {
  value = {
    for k, probe in azurerm_lb_probe.lb_probe_rb :  # ✅ correct
    k => {
      name     = probe.name
      id       = probe.id
      protocol = probe.protocol
      port     = probe.port
    }
  }
  description = "Load Balancer Probes with name, id, protocol, and port."
}


output "lb_probe_ids" {
  value = { for k, v in azurerm_lb_probe.lb_probe_rb : k => v.id }
}
