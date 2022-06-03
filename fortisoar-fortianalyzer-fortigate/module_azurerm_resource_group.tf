data "azurerm_resource_group" "resource_group" {
  count = local.rg_exists ? 1 : 0
  name  = local.resource_group_name
}

module "module_azurerm_resource_group" {
  count = local.rg_exists ? 0 : 1

  source = "../azure/rm/azurerm_resource_group"

  name     = local.resource_group_name
  location = local.resource_group_location
}

output "resource_groups" {
  value = var.enable_module_output ? module.module_azurerm_resource_group[*] : null
}