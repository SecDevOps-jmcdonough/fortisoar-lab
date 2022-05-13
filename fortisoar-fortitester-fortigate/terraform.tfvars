resource_group_name     = "student01_fortisoar_fortitester_fortigate"
resource_group_location = "eastus"

virtual_network_name          = "vnet_security"
virtual_network_address_space = ["10.135.0.0/16"]

fortigate_license_type = "payg" # Can be byol, flex, or payg
fortigate_offer        = "fortinet_fortigate-vm_v5"
fortigate_sku          = "fortinet_fg-vm_payg_2022" # byol and flex use: fortinet_fg-vm | payg use: fortinet_fg-vm_payg_2022
fortigate_size         = "Standard_F4s"
fortigate_ver          = "7.2.0"

fortigate_1_license_file = ""

fortitester_license_type = "byol"
fortitester_offer        = "fortinet-fortitester"
fortitester_sku          = "fts-vm-byol"
fortitester_size         = "Standard_F4s"
fortitester_ver          = "7.1.0"

fortitester_license_file = ""