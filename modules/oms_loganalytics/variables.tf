variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

#variable "password" {}

variable "logs" {
  type = "map"

  default = {
    "name"  = "vanilla-dev-poc-oms-log-analytics"
    "sku"   = "Free"
  }
}

variable "logs_solution" {
  type = "map"

  default = {
    "solution_name"         = "Containers"
#    "workspace_name"        = "jermainea"
#    "workspace_resource_id" = "jermainea"
    "publisher"             = "Microsoft"
    "product"               = "OMSGallery/Containers"
  }
}
