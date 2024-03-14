variable "cost_center_id" {
  description = "Id of the Cost Center"
  default = 3
}

variable "is_production" {
  description = "boolean value of is in Production"
  type = bool
  default = true
}

variable "rg_name_lab03" {
  description = "name of the resource group"
  type        = string
  default     = "rg-lab03"
  sensitive   = true
  validation {
    condition     = length(var.rg_name_lab03) > 3 && substr(var.rg_name_lab03, 0, 3) == "rg-"
    error_message = "The name should starts with rg- and contains more than 3 chars"
  }
}

variable "location_lab03" {
  description = "Set the location"
  type        = string
  #default     = "westeurope"

  validation {
    condition     = (anytrue([for loc in ["centralus", "centraleurope"] : loc == var.location_lab03]))
    error_message = "Should be one of the centralus or centraleurope"
  }
}

variable "apps_name" {
  type    = list(string)
  default = ["front", "back", "db"]
}

variable "allowed_locations" {
  type    = list(string)
  default = ["westeurope", "centralus", "centralfrance"]
}

variable "custom_tags" {
  type = map(string)
  default = {
    "project" = "frontend"
    "owner"   = "lody"
    "env"     = "UAT"
  }
}
