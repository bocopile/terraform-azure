variable "admin_username" {
  default = "bocopile"
}

variable "public_key_path" {
  default = "~/.ssh/bocopile-key.pub"
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "local_file" "public_key" {
  filename = var.public_key_path
}

output "public_ssh_key" {
  value = data.local_file.public_key.content
}