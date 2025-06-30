provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  resource_group_name = "aks-rg"
}

data "azurerm_virtual_network" "vm_vnet" {
  name                = "vnet-dbserver"
  resource_group_name = "vm-rg"
}

resource "azurerm_virtual_network_peering" "aks_to_vm" {
  name                      = "aks-to-dbserver"
  resource_group_name       = "aks-rg"
  virtual_network_name      = data.azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.vm_vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vm_to_aks" {
  name                      = "dbserver-to-aks"
  resource_group_name       = "vm-rg"
  virtual_network_name      = data.azurerm_virtual_network.vm_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_vnet.id
  allow_virtual_network_access = true
}