resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "${var.resource_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_D2as_v4"
  instances           = 3
  computer_name_prefix = "vmss"
  platform_fault_domain_count = 1
  admin_username      = "bocopile"

  custom_data         = base64encode(templatefile("${path.module}/scripts/startup-script.sh", {
    storage_account_name = azurerm_storage_account.storage.name,
    storage_account_key  = azurerm_storage_account.storage.primary_access_key
  }))

  source_image_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.gallery_resource_group}/providers/Microsoft.Compute/galleries/${var.gallery_name}/images/${var.gallery_image_name}/versions/${var.gallery_image_version}"

  upgrade_mode = "Automatic"

  rolling_upgrade_policy {
    max_batch_instance_percent         = 50
    max_unhealthy_instance_percent      = 50
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches          = "PT2M"
  }

  admin_ssh_key {
    username   = "bocopile"
    public_key = file("~/azure/bocopile-azure-key.pub")
  }

  network_interface {
    name    = "${var.resource_name}-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.ssh.id]
    }
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  health_probe_id = azurerm_lb_probe.lbprobe.id
}
