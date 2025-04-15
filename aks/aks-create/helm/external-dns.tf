data "azurerm_client_config" "current" {}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = "1.14.2" # 필요시 최신 버전 확인
  namespace  = "kube-system"

  create_namespace = false

  set {
    name  = "provider"
    value = "azure"
  }

  set {
    name  = "azure.resourceGroup"
    value = var.resource_group
  }

  set {
    name  = "azure.useManagedIdentityExtension"
    value = "true"
  }

  set {
    name  = "azure.useWorkloadIdentityExtension"
    value = "false"
  }

  set {
    name  = "txtOwnerId"
    value = "external-dns"
  }

  set {
    name  = "domainFilters[0]"
    value = "bocopile.io"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  set {
    name  = "registry"
    value = "txt"
  }

  set {
    name  = "interval"
    value = "1m"
  }

  set {
    name  = "sources[0]"
    value = "ingress"
  }

  depends_on = [
    helm_release.ingress_nginx
  ]
}