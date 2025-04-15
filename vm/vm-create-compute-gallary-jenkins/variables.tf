variable "resource" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "jenkins"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "Korea South"
}

variable "ssh_public_key_path" {
  description = "Path to SSH Public Key"
  type        = string
  default     = "~/azure/bocopile-azure-key.pub"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "bocopile"
}

variable "vm_type" {
  description = "Azure VM Type"
  type        = string
  default     = "Standard_E2bds_v5"
}

variable "vm_version" {
  description = "Azure VM version"
  type        = string
  default     = "1.0.2"
}

variable "vm_image_name" {
  description = "Azure VM image name"
  type        = string
  default     = "jenkins_vm_ubuntu_24"
}

variable "vm_gallery_name" {
  description = "Azure Gallery Name"
  type        = string
  default     = "devops"
}

variable "vm_resource_group_name" {
  description = "Azure Gallery resource group"
  type        = string
  default     = "devops-resource"
}

