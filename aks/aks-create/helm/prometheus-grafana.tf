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
    helm_release.ingress_nginx  # nginx가 먼저 설치된 후 실행
  ]
}