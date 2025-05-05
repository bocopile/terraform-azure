resource "azurerm_mysql_flexible_server" "main" {
  name                = "infra-mysql"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  administrator_login = "mysqladmin"
  administrator_password = "your-secure-password"
  sku_name            = "B_Standard_B1s"
  version             = "8.0"

  storage {
    size_gb = 32
  }

  authentication {
    active_directory_auth_enabled = false
  }

  delegated_subnet_id = azurerm_subnet.default.id
  private_dns_zone_id = null

}