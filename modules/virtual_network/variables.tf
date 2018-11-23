variable "virtual_network" {
  type = "map"

  default = {
    "name"          = "jermaine_goldencopy"
    "address_space" = "10.90.39.0/24"
  }
}

variable "subnet" {
  type = "map"

  default = {
    "name"          = "jermaine_goldencopy"
    "address_space" = "10.90.39.0/24"
  }
}