terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-bocopile"
  location = "Korea South"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-bocopile-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-koreasouth"

  kubernetes_version  = "1.32.2"

  default_node_pool {
    name                = "nodepool"
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    node_count          = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

module "helm_apps" {
  source         = "./helm"
  kube_config    = azurerm_kubernetes_cluster.aks.kube_config_raw
  cluster_name   = azurerm_kubernetes_cluster.aks.name
  resource_group = azurerm_resource_group.aks_rg.name
}