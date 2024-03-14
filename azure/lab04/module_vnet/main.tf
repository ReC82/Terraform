resource "azurerm_resource_group" "rgname" {
    name = var.rg_name
    location = "centralus"
}

resource "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    location = var.location_lab04
    resource_group_name = var.rg_name
    address_space = var.address_space_lab04
}

resource "azurerm_subnet" "subnet" {
    count = length(var.subnet_names_lab04)
    name = var.subnet_names_lab04[count.index]
    resource_group_name = var.rg_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet_prefix_lab04[count.index]]
}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
        subnet.name => subnet.id 
  }
}

###############
# OUTPUTS
###############

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
    value = azurerm_virtual_network.vnet.location
}

output "vnet_space" {
    value = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnet" {
    value = azurerm_virtual_network.vnet.subnet.*.id  
}
