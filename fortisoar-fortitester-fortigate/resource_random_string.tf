resource "random_string" "string" {
  length  = 30
  special = false
}

output "strings" {
  value = var.enable_module_output ? random_string.string : null
}