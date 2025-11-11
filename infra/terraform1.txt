# resource_groups = {
#   rg1 = {
#     name     = "rit-rg1"
#     location = "North Europe"
#   }

# }
# ######
# ######
# ######
# vnets = {
#   vnet1 = {
#     vnet_name     = "pahelavnet"
#     location      = "North Europe"
#     rg_name       = "rit-rg1"
#     address_space = ["10.0.0.0/23"] # 512 addresses
#     subnets = {
#       subnet1 = {
#         subnet_name             = "pahelasubnet"
#         subnet_address_prefixes = ["10.0.0.0/24"] # 256 addresses
#       }
#       subnet2 = {
#         subnet_name             = "dusrasubnet"
#         subnet_address_prefixes = ["10.0.1.0/25"] # 128 addresses
#       }
#       subnetab = {
#         subnet_name             = "AzureBastionSubnet"
#         subnet_address_prefixes = ["10.0.1.128/26"] # 10.0.0.128/26-24 - 64 to 256 addresses   
#       }
#       subnet3 = {
#         subnet_name             = "tisrasubnet"
#         subnet_address_prefixes = ["10.0.1.192/27"] # 32 addresses
#       }
#     }
#   }
# }


# #####
# #####
# #####
# nsg = {
#   web_nsg = {
#     nsg_name = "pahelansg"
#     location = "North Europe"
#     rg_name  = "rit-rg1"

#     security_rules = {
#       allow_http = {
#         security_rule_name         = "allow-http"
#         priority                   = 100
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "80"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#       }
#       # allow_ssh = {
#       #   security_rule_name         = "allow-ssh"
#       #   priority                   = 101
#       #   direction                  = "Inbound"
#       #   access                     = "Allow"
#       #   protocol                   = "Tcp"
#       #   source_port_range          = "*"
#       #   destination_port_range     = "22"
#       #   source_address_prefix      = "*"
#       #   destination_address_prefix = "*"
#       # }
#     }
#   }
#   empty_rule_nsg = {
#     nsg_name = "dusransg"
#     location = "North Europe"
#     rg_name  = "rit-rg1"
#   }
# }


# #####
# #####
# #####
# nics = {
#   nic1 = {
#     nic_name    = "pahelanic"
#     rg_name     = "rit-rg1"
#     location    = "North Europe"
#     vnet_name   = "pahelavnet"
#     subnet_name = "pahelasubnet"

#     ip_configurations = {
#       ipconfig1 = {
#         ip_config_name        = "pahela-internal"
#         private_ip_allocation = "Dynamic"
#         public_ip_name        = null # "bastionpip" 👈 bas naam
#       }
#     }
#   }

#   nic2 = {
#     nic_name    = "dusranic"
#     rg_name     = "rit-rg1"
#     location    = "North Europe"
#     vnet_name   = "pahelavnet"
#     subnet_name = "dusrasubnet"

#     ip_configurations = {
#       ipconfig2 = {
#         ip_config_name        = "dusra-internal"
#         private_ip_allocation = "Dynamic"
#         primary               = true
#         # public_ip_name        = "loadbalancerpip"
#       }
#       ipconfig3 = {
#         ip_config_name        = "tisra-internal"
#         private_ip_allocation = "Static"
#         private_ip_address    = "10.0.1.75"
#         public_ip_name        = null
#       }
#     }
#   }
# }


# #####
# #####
# #####

# pips = {
#   bastionpip = {
#     pip_name = "bastionpip"
#     location = "North Europe"
#     rg_name  = "rit-rg1"
#   }
#   loadbalancer = {
#     pip_name = "loadbalancerpip"
#     location = "North Europe"
#     rg_name  = "rit-rg1"
#   }
# }


# #####
# #####
# bastion = {
#   bastion1 = {
#     bastion_name = "pahelabastion"
#     location     = "North Europe"
#     rg_name      = "rit-rg1"
#     vnet_name    = "pahelavnet"
#     subnet_name  = "AzureBastionSubnet"
#     pip_name     = "bastionpip"

#     ip_configuration = {
#       name = "bastion-ipconfig"
#     }
#   }
# }

# #####
# #####
# #####
# nic_nsg_ids = {
#   nic_nsg_1 = {
#     nic_name = "pahelanic"
#     nsg_name = "pahelansg"
#     rg_name  = "rit-rg1"
#   }
#   nic_nsg_2 = {
#     nic_name = "dusranic"
#     nsg_name = "pahelansg"
#     rg_name  = "rit-rg1"
#   }
# }

# #####
# #####
# #####

# vms = {
#   frontend = {
#     vm_name                      = "frontendvm"
#     rg_name                      = "rit-rg1"
#     location                     = "North Europe"
#     vm_size                      = "Standard_B1s"
#     admin_username               = "frontendvm"
#     admin_password               = "Ritesh@12345"
#     nic_name                     = "pahelanic"
#     os_disk_caching              = "ReadWrite"
#     os_disk_storage_account_type = "Standard_LRS"
#     vm_publisher                 = "Canonical"
#     vm_offer                     = "0001-com-ubuntu-server-jammy"
#     vm_sku                       = "22_04-lts"
#     vm_version                   = "latest"
#     custom_data                  = <<-EOT
#       #!/bin/bash
#       sudo apt update
#       sudo apt upgrade -y
#       sudo apt install -y nginx
#       sudo rm -rf /var/www/html/*
#       git clone https://github.com/devopsinsiders/StreamFlix.git /var/www/html/
#       systemctl enable nginx
#       systemctl start nginx
#     EOT
#   }
#   backend = {
#     vm_name                      = "backendvm"
#     rg_name                      = "rit-rg1"
#     location                     = "North Europe"
#     vm_size                      = "Standard_B1s"
#     admin_username               = "backendvm"
#     admin_password               = "Ritesh@12345"
#     nic_name                     = "dusranic"
#     os_disk_caching              = "ReadWrite"
#     os_disk_storage_account_type = "Standard_LRS"
#     vm_publisher                 = "Canonical"
#     vm_offer                     = "0001-com-ubuntu-server-focal"
#     vm_sku                       = "20_04-lts"
#     vm_version                   = "latest"
#     custom_data                  = <<-EOT
#       #!/bin/bash
#       apt update -y
#       apt upgrade -y
#       apt install nginx -y
#       rm -rf  /var/www/html/*
#       git clone https://github.com/devopsinsiders/starbucks-clone.git /var/www/html/
#       systemctl enable nginx
#       systemctl start nginx
#     EOT
#   }
# }

# #####
# #####
# #####

# # sql_servers = {
# #   sqlserver1 = {
# #     sqlservername         = "ritsqlserver1q"
# #     rg_name               = "rit-rg1"
# #     location              = "North Europe"
# #     version               = "12.0"
# #     server_login_username = "server"
# #     server_login_password = "Ritesh@12345"

# #     public_network_access_enabled = false
# #   }
# #   sqlserver2 = {
# #     sqlservername         = "ritsqlserver2q"
# #     rg_name               = "rit-rg1"
# #     location              = "North Europe"
# #     version               = "12.0"
# #     server_login_username = "server"
# #     server_login_password = "Ritesh@12345"

# #     public_network_access_enabled = true
# #   }
# # }




# sql_servers = {
#   server1 = {
#     sqlservername                 = "ritsqlserver1123"
#     rg_name                       = "rit-rg1"
#     location                      = "North Europe"
#     version                       = "12.0"
#     server_login_username         = "server"
#     server_login_password         = "Ritesh@12345"
#     public_network_access_enabled = true
#   }

#   # server2 = {
#   #   sqlservername                 = "ritsqlserver12"
#   #   rg_name                       = "rit-rg1"
#   #   location                      = "North Europe"
#   #   version                       = "12.0"
#   #   server_login_username         = "server"
#   #   server_login_password         = "Ritesh@12345"
#   #   public_network_access_enabled = false
#   # }
# }

# firewall_rules = {
#   "server1-AllowIP1" = {
#     server_id        = "server1"
#     name             = "AllowIP1"
#     start_ip_address = "10.0.17.62"
#     end_ip_address   = "10.0.17.62"
#   }
#   "server1-AllowIP2" = {
#     server_id        = "server1"
#     name             = "AllowIP2"
#     start_ip_address = "49.43.131.11"
#     end_ip_address   = "49.43.131.11"
#   }
#   # "server2-AllowIP1" = {
#   #   server_id        = "server2"
#   #   name             = "AllowIP1"
#   #   start_ip_address = "20.0.0.1"
#   #   end_ip_address   = "20.0.0.10"
#   # }
# }




# sql_databases = {
#   db1 = {
#     name           = "appdb"
#     server_name    = "ritsqlserver1123"
#     resource_group = "rit-rg1"
#     sku_name       = "S0"
#   }
#   db2 = {
#     name           = "analyticsdb"
#     server_name    = "ritsqlserver1123"
#     resource_group = "rit-rg1"
#     sku_name       = "S1"
#     max_size_gb    = 20
#     zone_redundant = false
#   }
# }




# azurerm_lb_rb = {
#   lb1 = {
#     rg_name  = "rit-rg1"
#     pip_name = "loadbalancerpip"
#     lb_name  = "rit-loadbalancer"
#     location = "North Europe"
#     sku      = "Standard"
#     frontend_ip_config = [
#       {
#         name = "rit-frontend-ipconfig"
#       }
#     ]
#   }
# }

# backend_ap_rb = {
#   bap1 = {
#     lb_name           = "rit-loadbalancer"
#     rg_name           = "rit-rg1"
#     backend_pool_name = "rit-backend-pool"
#   }
# }

# nic_bp_association = {
#   firstassociation = {
#     nic_name                  = "pahelanic"
#     nic_rg_name               = "rit-rg1"
#     lb_name                   = "rit-loadbalancer"
#     rg_name                   = "rit-rg1"
#     backend_address_pool_name = "rit-backend-pool"
#     nic_ka_ip_config_name     = "pahela-internal"
#   }
#   secondassociation = {
#     nic_name                  = "dusranic"
#     nic_rg_name               = "rit-rg1"
#     lb_name                   = "rit-loadbalancer"
#     rg_name                   = "rit-rg1"
#     backend_address_pool_name = "rit-backend-pool"
#     nic_ka_ip_config_name     = "dusra-internal"
#   }
# }

# lb_probe = {
#   lb1 = {
#     probe_name     = "rit-health-probe"
#     probe_protocol = "Tcp"
#     probe_port     = 80
#     rg_name        = "rit-rg1"
#     lb_name        = "rit-loadbalancer"
#   }
# }

# lb_rule = {
#   lb1 = {
#     lb_name                         = "rit-loadbalancer"
#     rg_name                         = "rit-rg1"
#     backend_address_pool_db_ka_name = "rit-backend-pool"
#     lb_rule_name                    = "rit-lb-rule"
#     protocol                        = "Tcp"
#     frontend_port                   = 80
#     backend_port                    = 80
#     frontend_ip_configuration_name  = "rit-frontend-ipconfig"
#     probe_name                      = "rit-health-probe"
#   }
# }
