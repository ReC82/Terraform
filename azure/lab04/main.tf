resource "azurerm_resource_group" "rg" {
  name     = "myres"
  location = "West Europe"
}

module "vnet" {
  source              = "./module_vnet"
  rg_name             = azurerm_resource_group.rg.name
  address_space_lab04 = ["10.0.0.0/16"]
  subnet_prefix_lab04 = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names_lab04  = ["sub1", "sub2", "sub3"]

  depends_on = [azurerm_resource_group.rg]
}