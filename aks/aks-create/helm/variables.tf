variable "kube_config" {
  description = "Raw kubeconfig for AKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "resource_group" {
  description = "Azure resource group name"
  type        = string
}