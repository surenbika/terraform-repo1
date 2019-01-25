variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "password" {}

variable "mysql" {
  type = "map"

  default = {
    "name"            = "vanilladevmysql"
    "user"            = "devadmin"
    "version"         = "5.7"
    "ssl_enforcement" = "Disabled"
    "database_name"   = "devadmindb"
  }
}

variable "sku" {
  type = "map"

  default = {
    "name"     = "B_Gen5_2"
    "capacity" = 2
    "tier"     = "Basic"
    "family"   = "Gen5"
  }
}

variable "storage_profile" {
  type = "map"

  default = {
    "storage_mb"            = 103424
    "backup_retention_days" = 7
    "geo_redundant_backup"  = "Disabled"
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
