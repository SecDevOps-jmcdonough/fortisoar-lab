variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
  default     = ""
}

variable "resource_group_location" {
  description = "resource_group_location"
  type        = string
  default     = ""
}

variable "virtual_network_name" {
  description = "virtual_network_name"
  type        = string
  default     = ""
}

variable "virtual_network_address_space" {
  description = "virtual_network_address_space"
  type        = list(any)
  default     = []
}

variable "fortigate_license_type" {
  description = "FortiGate license type"
  default     = "payg"
}

variable "fortigate_offer" {
  description = "FortiGate image offer"
  default     = ""
}

variable "fortigate_sku" {
  description = "FortiGate image SKU"
  default     = ""
}

variable "fortigate_ver" {
  description = "FortiGate image version"
  default     = ""
}

variable "fortigate_size" {
  description = "FortiGate instance size"
  default     = ""
}

variable "fortigate_1_license_file" {
  description = "License file for FortiGate 1 VM."
  type        = string
  default     = ""
  validation {
    condition = (
      can(regex("^(|\\w*.lic)$", var.fortigate_1_license_file))
    )
    error_message = "Invalid license file. Options: \"\"|[0-9A-Za-z_]*.lic ."
  }
}

variable "fortitester_license_type" {
  description = "FortiTester license type"
  default     = "byol"
}

variable "fortitester_offer" {
  description = "FortiTester image offer"
  default     = ""
}

variable "fortitester_sku" {
  description = "FortiTester image SKU"
  default     = ""
}

variable "fortitester_ver" {
  description = "FortiTester image version"
  default     = ""
}

variable "fortitester_size" {
  description = "FortiTester instance size"
  default     = ""
}

variable "fortitester_license_file" {
  description = "License file for FortiTester VM."
  type        = string
  default     = ""
  validation {
    condition = (
      can(regex("^(|\\w*.lic)$", var.fortitester_license_file))
    )
    error_message = "Invalid license file. Options: \"\"|[0-9A-Za-z_]*.lic ."
  }
}

variable "connect_to_fmg" {
  default = ""
}

variable "forti_manager_ip" {
  default = ""
}

variable "forti_manager_serial" {
  default = ""
}

variable "enable_module_output" {
  description = "Enable/Disable module output"
  default     = true
}

variable "username" {
  description = "VM Username"
  default     = "azureuser"
}

variable "password" {
  description = "VM Password"
  default     = "Password123!!"
}