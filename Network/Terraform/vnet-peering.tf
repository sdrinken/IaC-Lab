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
# NSG: Allow Only ICMP from AKS VNet
###################################

resource "azurerm_network_security_group" "dbserver_nsg" {
  name                = "nsg-dbserver"
  location            = data.azurerm_virtual_network.vm_vnet.location
  resource_group_name = "rg-dbserver"

  security_rule {
    name                       = "Allow-ICMP-From-AKS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "Deny-All-Other-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "dbserver_nsg_assoc" {
  subnet_id                 = data.azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.dbserver_nsg.id
}
