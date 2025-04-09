resource "azurerm_public_ip" "lb_ip" {
  name                = "${var.resource}-lb-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.resource}-${random_string.unique_id.result}"
}

resource "azurerm_lb" "lb" {
  name                = "${var.resource}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

# ✅ 수정: resource_group_name 제거
resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "${var.resource}-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

# ✅ 수정: resource_group_name 제거
resource "azurerm_lb_probe" "ssh" {
  name            = "ssh-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 22
}

resource "azurerm_lb_probe" "http" {
  name            = "https-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_probe" "https" {
  name            = "https-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 443
}

resource "azurerm_lb_rule" "ssh" {
  name                           = "SSHRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.bepool.id
  ]

  probe_id = azurerm_lb_probe.ssh.id
}

resource "azurerm_lb_rule" "http" {
  name                           = "HTTSRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.bepool.id
  ]

  probe_id = azurerm_lb_probe.http.id
}

resource "azurerm_lb_rule" "https" {
  name                           = "HTTPSRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.bepool.id
  ]

  probe_id = azurerm_lb_probe.https.id
}