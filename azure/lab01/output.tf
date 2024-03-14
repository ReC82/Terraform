output "azure_public_ip" {
  value = azurerm_public_ip.pubip_example.ip_address
}