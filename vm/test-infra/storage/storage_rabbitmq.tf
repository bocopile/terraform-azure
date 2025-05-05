resource "azurerm_storage_account" "logstorage" {
  name                     = "logstorage${random_id.unique.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "logshare" {
  name                 = "logfiles"
  storage_account_name = azurerm_storage_account.logstorage.name
  quota                = 5120 # 5GB
}

resource "random_id" "unique" {
  byte_length = 4
}
