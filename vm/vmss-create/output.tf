output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}
