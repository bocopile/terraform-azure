resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.resource_name}-lb-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "${var.resource_name}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend-config"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lbprobe" {
  name                = "${var.resource_name}-health-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 4000
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lbrule" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 4000
  backend_port                   = 4000
  frontend_ip_configuration_name = "frontend-config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.lbprobe.id
}

resource "azurerm_lb_nat_pool" "ssh" {
  name                           = "ssh-nat-pool"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50009
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend-config"
}
