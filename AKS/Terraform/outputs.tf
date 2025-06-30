output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "nginx_lb_ip" {
  value = kubernetes_service.nginx_lb.status[0].load_balancer[0].ingress[0].ip
}