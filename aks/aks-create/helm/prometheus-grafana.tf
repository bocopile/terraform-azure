resource "helm_release" "prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"

  create_namespace = true

  values = [
    file("${path.module}/values/prometheus-values.yaml")
  ]

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.external_dns,
    helm_release.cert_manager
  ]
}