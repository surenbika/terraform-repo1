variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "logs" {
  type = "map"

  default = {
    "name"  = "vanilladevomsloganalytics"
    "sku"   = "PerNode"
  }
}

variable "logs_solution" {
  type = "map"

  default = {
    "solution_name"         = "Containers"
    "publisher"             = "Microsoft"
    "product"               = "OMSGallery/Containers"
  }
}
