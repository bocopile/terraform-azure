output "vm_public_ip" {
  description = "Public IP of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "storage_account_name" {
  description = "Storage Account Name"
  value       = azurerm_storage_account.storage.name
}
