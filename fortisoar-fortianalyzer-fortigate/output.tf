output "FortiSOAR" {
  value = format("https://%s", module.module_azurerm_public_ip["pip_fsr"].public_ip.ip_address)
}

output "FortiAnalyzer" {
  value = format("https://%s", module.module_azurerm_public_ip["pip_faz"].public_ip.ip_address)
}

output "FortiGate" {
  value = format("https://%s", module.module_azurerm_public_ip["pip_fgt"].public_ip.ip_address)
}

output "username" {
  value = format("username: %s", var.username)
}
output "password" {
  value = format("password: %s", var.password)
}
