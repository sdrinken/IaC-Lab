output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.dbserver.name
}

output "ssh_private_key" {
  description = "SSH Private Key to access the VM"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}