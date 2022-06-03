resource "local_file" "file" {
  filename = "vm_assets.json"
  content  = <<-EOT
  {
    "Results": [
    %{for vm in local.linux_virtual_machines~}
        ${jsonencode({ "name" = "${vm.name}", "ip" = "${module.module_azurerm_linux_virtual_machine[vm.name].linux_virtual_machine.private_ip_address}" })},
    %{endfor~}
    ]
  }
  EOT
}
