resource "azurerm_linux_virtual_machine_scale_set" "rabbitmq" {
  name                = "rabbitmq-vmss"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard_B2s"
  instances           = 3
  admin_username      = var.admin_username
  disable_password_authentication = true
  ssh_keys {
    path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    key_data = data.local_file.public_key.content
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  computer_name_prefix = "rabbitmq"
  subnet_id            = azurerm_subnet.default.id

  network_interface {
    name    = "rabbitmq-nic"
    primary = true

    ip_configuration {
      name      = "ipconfig1"
      subnet_id = azurerm_subnet.default.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.rabbitmq.id]
    }
  }

  health_probe_id = azurerm_lb_probe.rabbitmq.id


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/mount-log-share.sh", {
    STORAGE_ACCOUNT_NAME = azurerm_storage_account.logstorage.name
    STORAGE_KEY          = azurerm_storage_account.logstorage.primary_access_key
    FILE_SHARE_NAME      = azurerm_storage_share.logshare.name
  }))
}
