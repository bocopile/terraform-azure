provider "azurerm" {
  features {}
}

# 기존 리소스 그룹 조회
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# 기존 가상 네트워크 조회
data "azurerm_virtual_network" "existing_vnet" {
  name                = "sample-vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# 기존 서브넷 조회
data "azurerm_subnet" "existing_subnet" {
  name                 = "sample-subnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
}

# 공용 IP 주소 리소스 생성
resource "azurerm_public_ip" "public_ip" {
  name                         = "sample-exist-public-ip"
  location                     = data.azurerm_resource_group.existing_rg.location
  resource_group_name          = data.azurerm_resource_group.existing_rg.name
  allocation_method            = "Static"
  domain_name_label            = "sampleexistvm${random_string.unique_id.result}"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "sample-exist-nsg"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "22"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "443"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}

# 네트워크 인터페이스에 공용 IP 연결
resource "azurerm_network_interface" "nic" {
  name                      = "sample-exist-nic"
  location                  = data.azurerm_resource_group.existing_rg.location
  resource_group_name       = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true   # 기본 구성으로 설정
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 가상 머신 리소스
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "sample-exist-vm"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_E2bds_v5"
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(file("../cloud-init.txt"))
}

# 랜덤 문자열 생성 (도메인 이름에 사용)
resource "random_string" "unique_id" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "mystorage${random_string.unique_id.result}"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = data.azurerm_resource_group.existing_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}