variable "location" {
  default = "koreasouth"
}

variable "resource_group_name" {
  default = "devops-infra-resource"
}

variable "resource_name" {
  default = "devops-vmss"
}

# VMSS Autoscale 변수
variable "scale_min_capacity" {
  default = 3
}

variable "scale_max_capacity" {
  default = 5
}

variable "scale_default_capacity" {
  default = 3
}

variable "scale_out_threshold" {
  default = 80
}

variable "scale_out_change_count" {
  default = 1
}

variable "scale_out_cooldown" {
  default = "PT1M"
}

variable "scale_in_threshold" {
  default = 10
}

variable "scale_in_change_count" {
  default = 1
}

variable "scale_in_cooldown" {
  default = "PT2M"
}

# VMSS Image 변수
variable "subscription_id" {}
variable "gallery_resource_group" {
  default = "devops-resource"
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
