variable "location" {
  type    = string
  default = "westeurope"
}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "storage_account_name" {
  type    = string
  default = "mongodbbackupstest"
}
variable "storage_container_name" {
  type = string
  default = "backups"
}
variable "resource_group_name" {
  type = string
  default = "st-backup-rg"
}
