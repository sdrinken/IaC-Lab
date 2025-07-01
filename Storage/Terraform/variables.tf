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
  default = "mongodbbackupsdemo"
}
variable "resource_group_name" {
  type = string
  default = "st-backup-rg"
}
