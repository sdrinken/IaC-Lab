resource "azurerm_kubernetes_cluster" "aks" {
  name                = "private-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aksprivate"

  default_node_pool {
    name           = "nodepool"
    node_count     = 2
    vm_size        = "standard_d2s_v6"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

network_profile {
  network_plugin     = "azure"
  network_policy     = "azure"
  service_cidr       = "172.16.0.0/16"
  dns_service_ip     = "172.16.0.10"
}

  private_cluster_enabled = false

  role_based_access_control_enabled = true
}
