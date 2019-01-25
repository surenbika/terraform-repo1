variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "subscription_id" {}

variable "virtual_network" {
  type = "map"

  default = {
    "name"          = "vanilladevvirtualnetwork"
    "address_space" = "10.90.40.0/24"
  }
}

variable "subnet" {
  type = "map"

  default = {
    "name"          = "vanilladevsubnet"
    "address_prefix" = "10.90.40.0/24"
  }
}
