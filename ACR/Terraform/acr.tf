provider "azurerm" {
  features {}
}

variable "location" {
  default = "westeurope"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "resource_group" {
  description = "The existing resource group where AKS and ACR are/will be"
  type        = string
}

variable "aks_cluster_name" {
  description = "The name of the existing AKS cluster"
  type        = string
}

resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = var.resource_group
  location                 = var.location
  sku                      = "Standard"
  admin_enabled            = false
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "aks_pull_acr" {
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}