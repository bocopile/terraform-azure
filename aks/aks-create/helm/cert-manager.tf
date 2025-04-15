resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.4" # 최신 버전 확인 가능
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}