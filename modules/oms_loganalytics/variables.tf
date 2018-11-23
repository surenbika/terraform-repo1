variable "logs" {
  type = "map"

  default = {
    "name"  = "jermainegoldencopy"
    "sku"   = "Free"
  }
}

variable "logs_solution" {
  type = "map"

  default = {
    "solution_name"         = "Containers"
    "workspace_name"        = "jermaine_goldencopy"
    "workspace_resource_id" = "jermaine_goldencopy"
    "publisher"             = "Microsoft"
    "product"               = "OMSGallery/Containers"
  }
}