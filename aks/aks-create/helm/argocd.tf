resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.53.9"

  create_namespace = true

  values = [
    file("${path.module}/values/argocd-vaules.yaml")
  ]

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.external_dns,
    helm_release.cert_manager
  ]
}
