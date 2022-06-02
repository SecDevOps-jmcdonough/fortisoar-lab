resource_group_name     = "_fortisoar_fortianalyzer_fortigate"
resource_group_location = "eastus"

virtual_network_name          = "vnet_security"
virtual_network_address_space = ["10.135.0.0/16"]

fortigate_license_type   = "payg" # Can be byol, flex, or payg
fortigate_offer          = "fortinet_fortigate-vm_v5"
fortigate_sku            = "fortinet_fg-vm_payg_2022" # byol and flex use: fortinet_fg-vm | payg use: fortinet_fg-vm_payg_2022
fortigate_version        = "7.2.0"
fortigate_vm_size        = "Standard_F4s"
fortigate_1_license_file = ""

fortianalyzer_license_type = "byol"
fortianalyzer_offer        = "fortinet-fortianalyzer"
fortianalyzer_sku          = "fortinet-fortianalyzer"
fortianalyzer_version      = "7.2.0"
fortianalyzer_vm_size      = "Standard_D4s_v3"
fortianalyzer_license_file = ""
