resource "helm_release" "istio_base" {
  name       = "istio-base"
  namespace  = "istio-system"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.22.0"

  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  namespace  = "istio-system"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.22.0"

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  namespace  = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.22.0"

  create_namespace = true

  values = [
    file("${path.module}/values/kiali-values.yaml")
  ]

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.external_dns,
    helm_release.cert_manager,
    helm_release.istiod
  ]
}
