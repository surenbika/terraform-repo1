variable "resource_group_name" {}

variable "location" {}

variable "environment" {}

variable "keyvault_name" {
  type = "map"

  default = {
    "name"                            = "jermainea"
    "enabled_for_template_deployment" = "true"
  }
}

variable "tenant_id" {}

variable "object_id" {}

variable "subscription_id" {}

#variable "password" {}
