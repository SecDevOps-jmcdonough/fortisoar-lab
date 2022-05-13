locals {
  resource_groups = {
    (var.resource_group_name) = {
      name     = var.resource_group_name
      location = var.resource_group_location
    }
  }

  public_ips = {
    "pip_fsoar" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name              = "pip_fsoar"
      allocation_method = "Static"
      sku               = "Standard"
    }
    "pip_ftest" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name              = "pip_ftest"
      allocation_method = "Static"
      sku               = "Standard"
    }
    "pip_fgt" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name              = "pip_fgt"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }

  virtual_networks = {
    (var.virtual_network_name) = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name          = var.virtual_network_name
      address_space = var.virtual_network_address_space
    }
  }

  subnets = {
    "fortitester_mgmt" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "fortitester_mgmt"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 0)]
    }
    "fortitester_traffic_1" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "fortitester_traffic_1"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 1)]
    }
    "fortitester_traffic_2" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "fortitester_traffic_2"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 2)]
    }
    "utility" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "utility"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 3)]
    }
    "external" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "external"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 4)]
    }
    "internal" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "internal"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 5)]
    }
    "protected" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name             = "protected"
      vnet_name        = var.virtual_network_name
      address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network[var.virtual_network_name].virtual_network.address_space[0], 8, 6)]
    }
  }

  network_interfaces = {
    "nic_fortigate_1_1" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortigate_1_1"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["external"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["external"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = module.module_azurerm_public_ip["pip_fgt"].public_ip.id
        }
      ]
    }
    "nic_fortigate_1_2" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortigate_1_2"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["internal"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["internal"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_fortitester_1" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortitester_1"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["fortitester_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["fortitester_mgmt"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = module.module_azurerm_public_ip["pip_ftest"].public_ip.id
        }
      ]
    }
    "nic_fortitester_2" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortitester_2"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["fortitester_traffic_1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["fortitester_traffic_1"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_fortitester_3" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortitester_3"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["fortitester_traffic_2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["fortitester_traffic_2"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_fortisoar_1" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                          = "nic_fortisoar_1"
      enable_ip_forwarding          = true
      enable_accelerated_networking = true
      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["utility"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["utility"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = module.module_azurerm_public_ip["pip_fsoar"].public_ip.id
        }
      ]
    }
  }

  route_tables = {
    "rt_protected" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name = "rt_protected"
    }
  }

  routes = {
    "r_default" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name                   = "r_default"
      address_prefix         = "0.0.0.0/0"
      next_hop_in_ip_address = module.module_azurerm_network_interface["nic_fortigate_1_2"].network_interface.private_ip_address
      next_hop_type          = "VirtualAppliance"
      route_table_name       = module.module_azurerm_route_table["rt_protected"].route_table.name
    }
  }

  subnet_route_table_associations = {
    "protected" = {
      subnet_id      = module.module_azurerm_subnet["protected"].subnet.id
      route_table_id = module.module_azurerm_route_table["rt_protected"].route_table.id
    }
  }

  # used as the suffix part of the storage account name
  random_ids = {
    "storage_account_random_id" = {
      keepers_resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      byte_length                 = 8
    }
  }

  # storage account must be globally unique
  # capital letters, dashes, uderscores, etc. are not allowed in storage account names
  storage_accounts = {
    "sasoar" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name                     = format("sasoar%s", "${random_id.id["storage_account_random_id"].hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
  }

  network_security_groups = {
    "nsg_protected" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name = "nsg_protected"
    }
  }

  network_security_rules = {
    "nsr_protected_ingress" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name                        = "nsr_protected_ingress"
      priority                    = 1001
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.name
    },
    "nsr_protected_egress" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name

      name                        = "nsr_protected_egress"
      priority                    = 1002
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.name
    }
  }

  subnet_network_security_group_associations = {
    "protected_utility" = {
      subnet_id                 = module.module_azurerm_subnet["utility"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
    "protected_fortitester_mgmt" = {
      subnet_id                 = module.module_azurerm_subnet["fortitester_mgmt"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
    "protected_fortitester_traffic_1" = {
      subnet_id                 = module.module_azurerm_subnet["fortitester_traffic_1"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
    "protected_fortitester_traffic_2" = {
      subnet_id                 = module.module_azurerm_subnet["fortitester_traffic_2"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
    "protected_external" = {
      subnet_id                 = module.module_azurerm_subnet["external"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
    "protected_internal" = {
      subnet_id                 = module.module_azurerm_subnet["internal"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_protected"].network_security_group.id
    }
  }

  vm_image = {
    "fortigate" = {
      publisher = "fortinet"
      offer     = var.fortigate_offer
      sku       = var.fortigate_sku
      version   = var.fortigate_ver
      vm_size   = var.fortigate_size
    }
    "fortitester" = {
      publisher = "fortinet"
      offer     = var.fortitester_offer
      sku       = var.fortitester_sku
      version   = var.fortitester_ver
      vm_size   = var.fortitester_size
    }
  }

  vm_linux_image = {
    "OpenLogic" = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7_9-gen2"
      version   = "latest"
    }
  }

  linux_virtual_machines = {
    "vm_fortisoar" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name = "vm-fortisoar"
      size = "Standard_D8s_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_fortisoar_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "vm-fortisoar"

      disable_password_authentication = false

      os_disk_name                 = "disk-vm-fortisoar_OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["sasoar"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["OpenLogic"].publisher
      source_image_reference_offer     = local.vm_linux_image["OpenLogic"].offer
      source_image_reference_sku       = local.vm_linux_image["OpenLogic"].sku
      source_image_reference_version   = local.vm_linux_image["OpenLogic"].version

      custom_data = base64encode(templatefile("./fortisoar.tpl", {}))

      zone = null

      tags = null

      connection_type     = "ssh"
      connection_user     = var.username
      connection_password = var.password
      connection_host     = module.module_azurerm_public_ip["pip_fsoar"].public_ip.ip_address
    }
  }

  virtual_machines = {
    "vm_fgt" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name              = "vm-fgt"
      identity_identity = "SystemAssigned"

      #availability_set_id or zones can be set but not both. Both can be null
      availability_set_id = null
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_fortigate_1_1", "nic_fortigate_1_2"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_fortigate_1_1"].network_interface.id

      public_ip_address = module.module_azurerm_public_ip["pip_fgt"].public_ip.ip_address

      vm_size = local.vm_image["fortigate"].vm_size

      storage_image_reference_publisher = local.vm_image["fortigate"].publisher
      storage_image_reference_offer     = local.vm_image["fortigate"].offer
      storage_image_reference_sku       = local.vm_image["fortigate"].sku
      storage_image_reference_version   = local.vm_image["fortigate"].version

      plan_publisher = local.vm_image["fortigate"].publisher
      plan_product   = local.vm_image["fortigate"].offer
      plan_name      = local.vm_image["fortigate"].sku

      os_profile_admin_username = var.username
      os_profile_admin_password = var.password

      os_profile_linux_config_disable_password_authentication = false

      boot_diagnostics_enabled     = true
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["sasoar"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "disk_vm_fgt_os"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "disk_vm_fgt_data_01"
          managed_disk_type = "Premium_LRS"
          create_option     = "Empty"
          disk_size_gb      = "30"
          lun               = "0"
        }
      ]

      # FortiGate Configuration
      config_data = templatefile(
        "./fortios_config.conf", {
          host_name               = "vm-fgt"
          connect_to_fmg          = var.connect_to_fmg
          license_type            = var.fortigate_license_type
          forti_manager_ip        = var.forti_manager_ip
          forti_manager_serial    = var.forti_manager_serial
          license_file            = "${path.module}/${var.fortigate_1_license_file}"
          serial_number           = ""
          license_token           = ""
          api_key                 = random_string.string.id
          vnet_address_prefix     = module.module_azurerm_virtual_network["vnet_security"].virtual_network.address_space[0]
          external_subnet_gateway = cidrhost(module.module_azurerm_subnet["external"].subnet.address_prefixes[0], 1)
          internal_subnet_gateway = cidrhost(module.module_azurerm_subnet["internal"].subnet.address_prefixes[0], 1)
          port1_ip                = module.module_azurerm_network_interface["nic_fortigate_1_1"].network_interface.private_ip_address
          port1_netmask           = cidrnetmask(module.module_azurerm_subnet["external"].subnet.address_prefixes[0])
          port2_ip                = module.module_azurerm_network_interface["nic_fortigate_1_2"].network_interface.private_ip_address
          port2_netmask           = cidrnetmask(module.module_azurerm_subnet["internal"].subnet.address_prefixes[0])
        }
      )
    }
    "vm_fortitester" = {
      resource_group_name = module.module_azurerm_resource_group[var.resource_group_name].resource_group.name
      location            = module.module_azurerm_resource_group[var.resource_group_name].resource_group.location

      name              = "vm-fortitester"
      identity_identity = "SystemAssigned"

      #availability_set_id or zones can be set but not both. Both can be null
      availability_set_id = null
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_fortitester_1", "nic_fortitester_2", "nic_fortitester_3"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_fortitester_1"].network_interface.id

      public_ip_address = module.module_azurerm_public_ip["pip_ftest"].public_ip.ip_address

      vm_size = local.vm_image["fortitester"].vm_size

      storage_image_reference_publisher = local.vm_image["fortitester"].publisher
      storage_image_reference_offer     = local.vm_image["fortitester"].offer
      storage_image_reference_sku       = local.vm_image["fortitester"].sku
      storage_image_reference_version   = local.vm_image["fortitester"].version

      plan_publisher = local.vm_image["fortitester"].publisher
      plan_product   = local.vm_image["fortitester"].offer
      plan_name      = local.vm_image["fortitester"].sku

      os_profile_admin_username = var.username
      os_profile_admin_password = var.password

      os_profile_linux_config_disable_password_authentication = false

      boot_diagnostics_enabled     = true
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["sasoar"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "disk_vm_fortitester_OS"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "disk_vm_fortitester_data"
          managed_disk_type = "Premium_LRS"
          create_option     = "Empty"
          disk_size_gb      = "30"
          lun               = "0"
        }
      ]

      # FortiGate Configuration
      config_data = null
    }
  }

  role_assignments = {
    "vm_fgt" = {
      scope                = module.module_azurerm_resource_group[var.resource_group_name].resource_group.id,
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_fgt"].virtual_machine.identity[0].principal_id
    }
  }
}