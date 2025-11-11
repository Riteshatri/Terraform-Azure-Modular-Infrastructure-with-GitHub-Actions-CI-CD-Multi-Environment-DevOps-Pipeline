variable "pips" {
  description = "A map of public IP configurations"
  type = map(object({
    pip_name = string
    location = string
    rg_name  = string
  }))
}
