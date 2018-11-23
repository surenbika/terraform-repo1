module "global_variables" {
  source = "../global_variables"
} 

module "resource_group" {
  source = "../resource_group"
}

provider "azurerm" {
  alias           = "k8s_env"
  subscription_id = "${module.global_variables.subscription_id}"
}

resource "azurerm_key_vault" "keyvault" {
  name                            = "${lookup(var.keyvault_name, "name")}"
  location                        = "${module.global_variables.location}"
  resource_group_name             = "${module.global_variables.resource_group_name}"
  enabled_for_template_deployment = "${lookup(var.keyvault_name, "enabled_for_template_deployment")}"
  tenant_id                       = "${var.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${var.object_id}"

    key_permissions = []

    secret_permissions = [
      "get",
      "list",
      "set",
    ]
  }

  tags {
    environment   = "${module.global_variables.environment}"
    Service       = "Kubernetes"
  }

  provider = "azurerm.k8s_env"
}