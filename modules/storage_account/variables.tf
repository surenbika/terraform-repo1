variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

#variable "password" {}

variable "storage" {
  type = "map"

  default = {
    "name"                      = "vanilla-dev-poc-storage-account"
    "account_tier"              = "Standard"
    "account_replication_type"  = "GRS"
  }
}

variable "start_ip_address" {
    default = "213.249.255.154"
}

variable "end_ip_address" {
    default = "213.249.255.154"
}

variable "charset" {
    default = "latin1"
}

variable "collation" {
    default = "latin1_swedish_ci"
}
