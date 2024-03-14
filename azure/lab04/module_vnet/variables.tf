variable "location_lab04" {
    default = "centralus"
}

variable "rg_name" {
    default = "rg_vnet_lab04"
}

variable "vnet_name" {
    default = "vnet_lab04"
}

variable "address_space_lab04" {
    type = list(string)
    default = [ "192.168.1.1/16" ]
}

variable "subnet_names_lab04" {
    type = list(string)
    default = [ "sub1", "sub2" ]
}

variable "subnet_prefix_lab04" {
    type = list(string)
    default = [ "192.168.1.0/24" , "192.168.2.0/24" ]  
}