variable "rg_name" {
  type    = string
  default = "rg_linux"
}

variable "rg_location" {
  type    = string
  default = "francecentral"
}

variable "vnet_name" {
  type    = string
  default = "vnet_linux"
}

variable "subnet_name" {
  type    = string
  default = "subnet_linux_1"
}

variable "subnet_name_for_db" {
  type    = string
  default = "subnet_linux_db"
}

variable "pub_ip_name" {
  type    = string
  default = "pub_ip_linux_1"
}

variable "netsg_name" {
  type    = string
  default = "netsg_linux"
}

variable "netsg_db_name" {
  type    = string
  default = "nets_db_linux"
}

variable "netint_name" {
  type    = string
  default = "net01_linux"
}

variable "netint_db_name" {
  type    = string
  default = "net01_db_linux"
}



variable "vm_name" {
  type    = string
  default = "Prod_Linux_VM01"
}

variable "vm_db_name" {
  type    = string
  default = "Prod_Linux_DB_VM01"
}