variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "sample-resource"
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
