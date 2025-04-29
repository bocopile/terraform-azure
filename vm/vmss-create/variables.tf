variable "location" {
  default = "koreasouth"
}

variable "resource_name" {
  default = "vmss"
}

variable "resource_group_name" {
  default = "vmss-resource"
}

variable "gallery_name" {
  default = "devops"
}

variable "gallery_image_name" {
  default = "node_vm_ubuntu_24"
}

variable "gallery_image_version" {
  default = "1.0.11"
}

variable "gallery_resource_group" {
  default = "devops-resource"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
}
