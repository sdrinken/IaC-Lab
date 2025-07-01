provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "storage_account_name" {
  type = string
}

resource "azurerm_storage_account" "backup_sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "backup_container" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.backup_sa.name
  container_access_type = "blob"  # public read access for blobs
}

output "storage_account_name" {
  value = azurerm_storage_account.backup_sa.name
}

output "storage_container_name" {
  value = azurerm_storage_container.backup_container.name
}