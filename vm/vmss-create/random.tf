resource "random_string" "unique_id" {
  length  = 10
  special = false
  upper   = false
}
