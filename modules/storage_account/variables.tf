variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "storage" {
  type = "map"

  default = {
    "name"                      = "vanilladevstorageaccount"
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
