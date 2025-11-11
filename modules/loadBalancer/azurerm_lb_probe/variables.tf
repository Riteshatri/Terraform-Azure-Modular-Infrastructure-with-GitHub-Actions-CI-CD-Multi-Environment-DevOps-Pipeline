variable "lb_probe" {
  type = map(object({
    probe_name     = string
    probe_protocol = string
    probe_port     = number
    rg_name        = string
    lb_name        = string
  }))
}
