variable "storage" {
  type = "map"

  default = {
    "name"                      = "jermainegoldencopy"
    "account_tier"              = "Standard"
    "account_replication_type"  = "GRS"
  }
}