provider "azurerm" {
  features {}
}

###############
# Data Sources
###############

data "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  resource_group_name = "aks-private-rg"
}

data "azurerm_virtual_network" "vm_vnet" {
  name                = "vnet-dbserver"
  resource_group_name = "rg-dbserver"
}

data "azurerm_subnet" "vm_subnet" {
  name                 = "subnet-dbserver"
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name
  resource_group_name  = "rg-dbserver"
}

#################
# VNet Peering
#################

resource "azurerm_virtual_network_peering" "aks_to_vm" {
  name                      = "aks-to-dbserver"
  resource_group_name       = "aks-private-rg"
  virtual_network_name      = data.azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.vm_vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vm_to_aks" {
  name                      = "dbserver-to-aks"
  resource_group_name       = "rg-dbserver"
  virtual_network_name      = data.azurerm_virtual_network.vm_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_vnet.id
  allow_virtual_network_access = true
}

###################################
# Reference existing NSG
###################################

data "azurerm_network_security_group" "dbserver_nsg" {
  name                = "nsg-dbserver"
  resource_group_name = "rg-dbserver"
}

###################################
# Add ICMP rule to existing NSG
###################################

resource "azurerm_network_security_rule" "allow_icmp_from_aks" {
  name                        = "Allow-ICMP-From-AKS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_network_security_group.dbserver_nsg.resource_group_name
  network_security_group_name = data.azurerm_network_security_group.dbserver_nsg.name
}
