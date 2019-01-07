provider "azurerm" {
  alias           = "k8s_env"
  subscription_id = "${var.subscription_id}"
}

resource "azurerm_key_vault" "keyvault" {

  #depends_on = ["module.vnet"]

  name                            = "${lookup(var.keyvault_name, "name")}"
  resource_group_name             = "${var.resource_group_name}"
  location                        = "${var.location}"
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
    environment   = "${var.environment}"
    Service       = "Kubernetes"
  }

  provider = "azurerm.k8s_env"
}