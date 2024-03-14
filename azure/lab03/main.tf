locals {
  common_tags = {
    CostCenter = var.cost_center_id
    Production = var.is_production
  }
}

resource "azurerm_resource_group" "lab03_rg" {
  name     = var.rg_name_lab03
  location = var.location_lab03
  tags     = local.common_tags
}

resource "azurerm_resource_group" "lab03_rg_2" {
  for_each = {
    dev  = "eastus"
    prod = "westeurope"
    test = "centralus"
  }

  name     = each.key
  location = each.value
}

resource "azurerm_resource_group" "lab03_rg_3" {
  count    = 3
  name     = "app-${count.index}"
  location = "centralus"
}

resource "azurerm_resource_group" "lab03_rg_4" {
  count    = length(var.apps_name)
  name     = var.apps_name[count.index]
  location = "centralus"
}

resource "azurerm_resource_group" "lab03_rg_5" {
  name     = "dev-rg"
  location = var.location_lab03 != "" ? var.location_lab03 : "westeurope"
}

