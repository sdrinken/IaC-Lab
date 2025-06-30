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
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  private_cluster_enabled = false

  role_based_access_control_enabled = true
}
