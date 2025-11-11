resource_groups = {
  rg1 = {
    name     = "rit-prod-rg1"
    location = "North Europe"
  }
}


vnets = {
  vnet1 = {
    vnet_name     = "pahelavnet-prod"
    location      = "North Europe"
    rg_name       = "rit-prod-rg1"
    address_space = ["10.0.0.0/23"]
    subnets = {
      subnet1  = { subnet_name = "pahelasubnet", subnet_address_prefixes = ["10.0.0.0/24"] }
      subnet2  = { subnet_name = "dusrasubnet", subnet_address_prefixes = ["10.0.1.0/25"] }
      subnetab = { subnet_name = "AzureBastionSubnet", subnet_address_prefixes = ["10.0.1.128/26"] }
      subnet3  = { subnet_name = "tisrasubnet", subnet_address_prefixes = ["10.0.1.192/27"] }
    }
  }
}

nsg = {
  web_nsg = {
    nsg_name = "pahelansg-prod"
    location = "North Europe"
    rg_name  = "rit-prod-rg1"
    security_rules = {
      allow_http = {
        security_rule_name         = "allow-http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
  empty_rule_nsg = {
    nsg_name = "dusransg-prod"
    location = "North Europe"
    rg_name  = "rit-prod-rg1"
  }
}

nics = {
  nic1 = {
    nic_name    = "pahelanic-prod"
    rg_name     = "rit-prod-rg1"
    location    = "North Europe"
    vnet_name   = "pahelavnet-prod"
    subnet_name = "pahelasubnet"
    ip_configurations = {
      ipconfig1 = {
        ip_config_name        = "pahela-internal-prod"
        private_ip_allocation = "Dynamic"
        public_ip_name        = null
      }
    }
  }
  nic2 = {
    nic_name    = "dusranic-prod"
    rg_name     = "rit-prod-rg1"
    location    = "North Europe"
    vnet_name   = "pahelavnet-prod"
    subnet_name = "dusrasubnet"
    ip_configurations = {
      ipconfig2 = {
        ip_config_name        = "dusra-internal-prod"
        private_ip_allocation = "Dynamic"
        primary               = true
      }
      ipconfig3 = {
        ip_config_name        = "tisra-internal-prod"
        private_ip_allocation = "Static"
        private_ip_address    = "10.0.1.75"
        public_ip_name        = null
      }
    }
  }
}

pips = {
  bastionpip   = { pip_name = "bastionpip-prod", location = "North Europe", rg_name = "rit-prod-rg1" }
  loadbalancer = { pip_name = "loadbalancerpip-prod", location = "North Europe", rg_name = "rit-prod-rg1" }
}

bastion = {
  bastion1 = {
    bastion_name     = "pahelabastion-prod"
    location         = "North Europe"
    rg_name          = "rit-prod-rg1"
    vnet_name        = "pahelavnet-prod"
    subnet_name      = "AzureBastionSubnet"
    pip_name         = "bastionpip-prod"
    ip_configuration = { name = "bastion-ipconfig-prod" }
  }
}

nic_nsg_ids = {
  nic_nsg_1 = { nic_name = "pahelanic-prod", nsg_name = "pahelansg-prod", rg_name = "rit-prod-rg1" }
  nic_nsg_2 = { nic_name = "dusranic-prod", nsg_name = "pahelansg-prod", rg_name = "rit-prod-rg1" }
}

vms = {
  frontend = {
    vm_name                      = "frontendvm-prod"
    rg_name                      = "rit-prod-rg1"
    location                     = "North Europe"
    vm_size                      = "Standard_B1s"
    admin_username               = "frontendvm"
    admin_password               = "Ritesh@12345"
    nic_name                     = "pahelanic-prod"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    vm_publisher                 = "Canonical"
    vm_offer                     = "0001-com-ubuntu-server-jammy"
    vm_sku                       = "22_04-lts"
    vm_version                   = "latest"
    custom_data                  = <<-EOT
      #!/bin/bash
      sudo apt update
      sudo apt upgrade -y
      sudo apt install -y nginx
      sudo rm -rf /var/www/html/*
      git clone https://github.com/devopsinsiders/StreamFlix.git /var/www/html/
      systemctl enable nginx
      systemctl start nginx
    EOT
  }
  backend = {
    vm_name                      = "backendvm-prod"
    rg_name                      = "rit-prod-rg1"
    location                     = "North Europe"
    vm_size                      = "Standard_B1s"
    admin_username               = "backendvm"
    admin_password               = "Ritesh@12345"
    nic_name                     = "dusranic-prod"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    vm_publisher                 = "Canonical"
    vm_offer                     = "0001-com-ubuntu-server-focal"
    vm_sku                       = "20_04-lts"
    vm_version                   = "latest"
    custom_data                  = <<-EOT
      #!/bin/bash
      apt update -y
      apt upgrade -y
      apt install nginx -y
      rm -rf  /var/www/html/*
      git clone https://github.com/devopsinsiders/starbucks-clone.git /var/www/html/
      systemctl enable nginx
      systemctl start nginx
    EOT
  }
}

sql_servers = {
  server1 = {
    sqlservername                 = "ritsqlserver1123-prod"
    rg_name                       = "rit-prod-rg1"
    location                      = "North Europe"
    version                       = "12.0"
    server_login_username         = "server"
    server_login_password         = "Ritesh@12345"
    public_network_access_enabled = true
  }
}

firewall_rules = {
  "server1-AllowIP1" = { server_id = "server1", name = "AllowIP1", start_ip_address = "10.0.17.62", end_ip_address = "10.0.17.62" }
  "server1-AllowIP2" = { server_id = "server1", name = "AllowIP2", start_ip_address = "49.43.131.11", end_ip_address = "49.43.131.11" }
}

sql_databases = {
  db1 = { name = "appdb", server_name = "ritsqlserver1123-prod", resource_group = "rit-prod-rg1", sku_name = "S0" }
  db2 = { name = "analyticsdb", server_name = "ritsqlserver1123-prod", resource_group = "rit-prod-rg1", sku_name = "S1", max_size_gb = 20, zone_redundant = false }
}

azurerm_lb_rb = {
  lb1 = {
    rg_name            = "rit-prod-rg1"
    pip_name           = "loadbalancerpip-prod"
    lb_name            = "rit-loadbalancer-prod"
    location           = "North Europe"
    sku                = "Standard"
    frontend_ip_config = [{ name = "rit-frontend-ipconfig-prod" }]
  }
}

backend_ap_rb = {
  bap1 = { lb_name = "rit-loadbalancer-prod", rg_name = "rit-prod-rg1", backend_pool_name = "rit-backend-pool-prod" }
}

nic_bp_association = {
  firstassociation  = { nic_name = "pahelanic-prod", nic_rg_name = "rit-prod-rg1", lb_name = "rit-loadbalancer-prod", rg_name = "rit-prod-rg1", backend_address_pool_name = "rit-backend-pool-prod", nic_ka_ip_config_name = "pahela-internal-prod" }
  secondassociation = { nic_name = "dusranic-prod", nic_rg_name = "rit-prod-rg1", lb_name = "rit-loadbalancer-prod", rg_name = "rit-prod-rg1", backend_address_pool_name = "rit-backend-pool-prod", nic_ka_ip_config_name = "dusra-internal-prod" }
}

lb_probe = {
  lb1 = { probe_name = "rit-health-probe-prod", probe_protocol = "Tcp", probe_port = 80, rg_name = "rit-prod-rg1", lb_name = "rit-loadbalancer-prod" }
}

lb_rule = {
  lb1 = {
    lb_name                         = "rit-loadbalancer-prod"
    rg_name                         = "rit-prod-rg1"
    backend_address_pool_db_ka_name = "rit-backend-pool-prod"
    lb_rule_name                    = "rit-lb-rule-prod"
    protocol                        = "Tcp"
    frontend_port                   = 80
    backend_port                    = 80
    frontend_ip_configuration_name  = "rit-frontend-ipconfig-prod"
    probe_name                      = "rit-health-probe-prod"
  }
}
