resource "random_string" "storage_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.resource_name}storage${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "logshare"
  storage_account_id  = azurerm_storage_account.storage.id
  quota                = 100  # 100GB
}
