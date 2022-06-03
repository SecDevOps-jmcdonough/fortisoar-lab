variable "enable_module_output" {
  description = "Enable/Disable module output"
  default     = false
}

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

variable "fortigate_version" {
  description = "FortiGate image version"
  default     = ""
}

variable "fortigate_vm_size" {
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

variable "fortianalyzer_license_type" {
  description = "FortiAnalyzer license type"
  default     = "byol"
}

variable "fortianalyzer_offer" {
  description = "FortiAnalyzer image offer"
  default     = ""
}

variable "fortianalyzer_sku" {
  description = "FortiAnalyzer image SKU"
  default     = ""
}

variable "fortianalyzer_version" {
  description = "FortiAnalyzer image version"
  default     = ""
}

variable "fortianalyzer_vm_size" {
  description = "FortiAnalyzer instance size"
  default     = ""
}

variable "fortianalyzer_license_file" {
  description = "License file for FortiAnalyzer VM."
  type        = string
  default     = ""
  validation {
    condition = (
      can(regex("^(|\\w*.lic)$", var.fortianalyzer_license_file))
    )
    error_message = "Invalid license file. Options: \"\"|[0-9A-Za-z_]*.lic ."
  }
}

variable "username" {
  description = "VM Username"
  default     = "azureuser"
}

variable "password" {
  description = "VM Password"
  default     = "123Password#@!"
}

variable "student" {
  description = "Student ID"
}

variable "rg_exists" {
  description = "Does the Resource Group already exist?"
}