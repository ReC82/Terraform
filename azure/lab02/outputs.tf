output "vm_ip" {
  value = azurerm_public_ip.pubip_linux.ip_address
}

output "vm_priv_key" {
  value     = tls_private_key.ssh_key_linux_openssh.private_key_openssh
  sensitive = true
}


output "vm_db_ip" {
  value = azurerm_network_interface.netint_db_linux.private_ip_address
}

output "vm_web_ip" {
  value = azurerm_network_interface.netint_linux.private_ip_address
}