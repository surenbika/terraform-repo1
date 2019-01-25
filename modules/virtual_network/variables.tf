variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "subscription_id" {}

#variable "password" {}

variable "virtual_network" {
  type = "map"

  default = {
    "name"          = "vanilla-dev-poc-virtual-network"
    "address_space" = "10.90.40.0/24"
  }
}

variable "subnet" {
  type = "map"

  default = {
    "name"          = "vanilla-dev-poc-subnet"
    "address_space" = "10.90.40.0/24"
  }
}
