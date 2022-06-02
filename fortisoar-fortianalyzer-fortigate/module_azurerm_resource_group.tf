locals {
  create_rg = true
}

data "azurerm_resource_group" "resource_group" {
  name = local.resource_group_name
}

module "module_azurerm_resource_group" {
  count = local.create_rg ? 1 : 0

  source = "../azure/rm/azurerm_resource_group"

  name     = local.resource_group_name
  location = var.resource_group_location
}

output "resource_groups" {
  value = var.enable_module_output ? module.module_azurerm_resource_group[*] : null
}