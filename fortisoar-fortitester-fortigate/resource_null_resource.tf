resource "null_resource" "fortisoar_deploy" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    fortisoar_id = module.module_azurerm_linux_virtual_machine["vm_fortisoar"].linux_virtual_machine.id
  }

  connection {
    type     = "ssh"
    user     = var.username
    password = var.password
    host     = module.module_azurerm_public_ip["pip_fsoar"].public_ip.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 300",
      "wget https://repo.fortisoar.fortinet.com/7.2.0/install-fortisoar-7.2.0.bin",
      "chmod +x install-fortisoar-7.2.0.bin",
      "export fsr_edition=enterprise",
      "sudo --preserve-env=fsr_edition ./install-fortisoar-7.2.0.bin"
    ]
  }
}

# resource "null_resource" "fortisoar_configure" {
#   # Changes to any instance of the cluster requires re-provisioning
#   triggers = {
#     fortisoar_id = module.module_azurerm_linux_virtual_machine["vm_fortisoar"].linux_virtual_machine.id
#   }

#   connection {
#     type     = "ssh"
#     user     = var.username
#     password = var.password
#     host     = module.module_azurerm_public_ip["pip_fsoar"].public_ip.ip_address
#   }

#   depends_on = [null_resource.fortisoar_deploy]

#   provisioner "file" {
#     content     = "test"
#     destination = "./test.txt"
#   }
# }