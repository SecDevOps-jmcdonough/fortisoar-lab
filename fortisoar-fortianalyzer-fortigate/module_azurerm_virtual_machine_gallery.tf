data "azurerm_shared_image" "shared_image" {
  name                = "FortiSOAR"
  gallery_name        = "Fortinet_Images"
  resource_group_name = "FTNT-Compute-Gallery"
}

resource "azurerm_virtual_machine" "virtual_machine_gallery" {

  for_each = local.virtual_machines_gallery

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.value.name
  vm_size             = each.value.size

  network_interface_ids = each.value.network_interface_ids

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_shared_image.shared_image.id
  }

  storage_os_disk {
    name              = "disk_vm_fsr_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}