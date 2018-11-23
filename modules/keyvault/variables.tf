variable "keyvault_name" {
  type = "map"

  default = {
    "name"                            = "jermainegoldencopy"
    "enabled_for_template_deployment" = "true"
  }
}

variable "tenant_id" {}

variable "object_id" {}