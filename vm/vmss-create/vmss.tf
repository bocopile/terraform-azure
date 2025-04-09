resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "${var.resource}-scaleset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_E2bds_v5"
  instances           = 1
  admin_username      = var.admin_username
  upgrade_mode        = "Manual"

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "${var.resource}-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "${var.resource}-vmss-ip"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      application_security_group_ids = [
        azurerm_application_security_group.asg.id
      ]
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.bepool.id
      ]
    }
  }

  custom_data = base64encode(file("../cloud-init.txt"))
}
