# Configure the Azure provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # https://developer.hashicorp.com/terraform/language/expressions/version-constraints
      version = "3.95.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }

  #https://developer.hashicorp.com/terraform/language/settings
  required_version = ">= 1.1.0"
}

resource "azurerm_resource_group" "rg_example" {
  name = "rg_lab01"
  # Where find those ? https://github.com/claranet/terraform-azurerm-regions/blob/master/REGIONS.md 
  location = var.location
}

resource "azurerm_virtual_network" "vnet_example" {
  name                = "vnet_lab01"
  resource_group_name = azurerm_resource_group.rg_example.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_example.location
}

resource "azurerm_subnet" "subnet_example" {
  name                 = "subnet_lab01_internal"
  resource_group_name  = azurerm_resource_group.rg_example.name
  virtual_network_name = azurerm_virtual_network.vnet_example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic_example" {
  name                = "nic_lab01"
  resource_group_name = azurerm_resource_group.rg_example.name
  location            = azurerm_resource_group.rg_example.location
  ip_configuration {
    name                          = "nic_lab01_config"
    subnet_id                     = azurerm_subnet.subnet_example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "pubip_example" {
  name                = "pubip_lab01"
  resource_group_name = azurerm_resource_group.rg_example.name
  location            = azurerm_resource_group.rg_example.location
  allocation_method   = "Static"

  tags = {
    environment = "Lab01"
  }
}

resource "azurerm_windows_virtual_machine" "vm-example" {
  name                = "vm-lab01"
  resource_group_name = azurerm_resource_group.rg_example.name
  location            = azurerm_resource_group.rg_example.location
  size                = "Standard_F2"
  admin_username      = "rootUser"
  admin_password      = "P@ssw0rd!123"
  network_interface_ids = [
    azurerm_network_interface.nic_example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


