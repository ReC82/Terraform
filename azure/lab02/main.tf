resource "azurerm_resource_group" "rg_linux" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    env = "prod"
  }
}

resource "azurerm_virtual_network" "vnet_linux" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg_linux.location
  resource_group_name = azurerm_resource_group.rg_linux.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    env = "prod"
  }
}

resource "azurerm_subnet" "subnet_linux" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_linux.name
  virtual_network_name = azurerm_virtual_network.vnet_linux.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_subnet" "subnet_linux_db" {
  name                 = var.subnet_name_for_db
  resource_group_name  = azurerm_resource_group.rg_linux.name
  virtual_network_name = azurerm_virtual_network.vnet_linux.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "pubip_linux" {
  name                = var.pub_ip_name
  location            = azurerm_resource_group.rg_linux.location
  allocation_method   = "Dynamic"
  resource_group_name = azurerm_resource_group.rg_linux.name
  tags = {
    env = "prod"
  }

}

#########################
# Web Security Group
#########################
resource "azurerm_network_security_group" "netsg_linux" {
  name                = var.netsg_name
  location            = azurerm_resource_group.rg_linux.location
  resource_group_name = azurerm_resource_group.rg_linux.name
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "MYSQL"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    env = "prod"
  }
}

#########################
# DB Security Group
#########################
resource "azurerm_network_security_group" "netsg_db_linux" {
  name                = var.netsg_db_name
  location            = azurerm_resource_group.rg_linux.location
  resource_group_name = azurerm_resource_group.rg_linux.name
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "MYSQL"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    env = "prod"
  }
}

######################
# Web Nic
######################
resource "azurerm_network_interface" "netint_linux" {
  name                = var.netint_name
  location            = azurerm_resource_group.rg_linux.location
  resource_group_name = azurerm_resource_group.rg_linux.name
  ip_configuration {
    name                          = "nicConf01"
    subnet_id                     = azurerm_subnet.subnet_linux.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip_linux.id
  }

  tags = {
    env = "prod"
  }

}

######################
# Db Nic
######################

resource "azurerm_network_interface" "netint_db_linux" {
  name                = var.netint_db_name
  location            = azurerm_resource_group.rg_linux.location
  resource_group_name = azurerm_resource_group.rg_linux.name
  ip_configuration {
    name                          = "nicDBConf01"
    subnet_id                     = azurerm_subnet.subnet_linux_db.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    env = "prod"
  }

}

resource "azurerm_network_interface_security_group_association" "netint_sga" {
  network_interface_id      = azurerm_network_interface.netint_linux.id
  network_security_group_id = azurerm_network_security_group.netsg_linux.id
}

resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.rg_linux.name
  }
  byte_length = 8
}

####################
# Web Storage Account
####################
resource "azurerm_storage_account" "storacc_linux" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg_linux.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = azurerm_resource_group.rg_linux.name
  tags = {
    env = "prod"
  }
}

####################
# DB Storage Account
####################
resource "azurerm_storage_account" "storacc_db_linux" {
  name                     = "diagdb${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg_linux.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = azurerm_resource_group.rg_linux.name
  tags = {
    env = "prod"
  }
}

#####################
# SSH KEY
#####################
resource "tls_private_key" "ssh_key_linux_openssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

###########################
# Web VM
###########################
resource "azurerm_linux_virtual_machine" "azulinvm01" {
  name                            = var.vm_name
  location                        = azurerm_resource_group.rg_linux.location
  network_interface_ids           = [azurerm_network_interface.netint_linux.id]
  admin_username                  = "rooty"
  disable_password_authentication = true
  resource_group_name             = azurerm_resource_group.rg_linux.name
  size                            = "Standard_DS1_v2"
  os_disk {
    name                 = "ProdLinuxDisk01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "LIN-PROD-01"

  admin_ssh_key {
    username   = "rooty"
    public_key = tls_private_key.ssh_key_linux_openssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storacc_linux.primary_blob_endpoint
  }

  tags = {
    env = "prod"
  }
}

###########################
# DB VM
###########################

resource "azurerm_linux_virtual_machine" "azulinvm_db_01" {
  name                            = var.vm_db_name
  location                        = azurerm_resource_group.rg_linux.location
  network_interface_ids           = [azurerm_network_interface.netint_db_linux.id]
  admin_username                  = "rooty"
  disable_password_authentication = false
  admin_password = "D3h2dz9x."
  resource_group_name             = azurerm_resource_group.rg_linux.name
  size                            = "Standard_DS1_v2"
  os_disk {
    name                 = "ProdLinux_DB_Disk01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "LIN-PROD-DB-01"

  admin_ssh_key {
    username   = "rooty"
    public_key = tls_private_key.ssh_key_linux_openssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storacc_db_linux.primary_blob_endpoint
  }

  tags = {
    env = "prod"
  }
}