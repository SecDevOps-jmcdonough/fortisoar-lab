module "module_azurerm_linux_virtual_machine" {
  for_each = local.linux_virtual_machines

  source = "../azure/rm/azurerm_linux_virtual_machine"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name = each.value.name
  size = each.value.size

  availability_set_id   = each.value.availability_set_id
  network_interface_ids = each.value.network_interface_ids

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password
  computer_name  = each.value.computer_name
  custom_data    = each.value.custom_data

  disable_password_authentication = each.value.disable_password_authentication

  os_disk_name                 = each.value.os_disk_name
  os_disk_caching              = each.value.os_disk_caching
  os_disk_storage_account_type = each.value.os_disk_storage_account_type

  allow_extension_operations = each.value.allow_extension_operations

  storage_account_uri = each.value.storage_account_uri

  identity = each.value.identity

  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version

  zone = each.value.zone

  tags = each.value.tags
}

output "linux_virtual_machines" {
  value     = var.enable_module_output ? module.module_azurerm_linux_virtual_machine[*] : null
  sensitive = true
}