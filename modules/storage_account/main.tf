module "global_variables" {
    source = "../global_variables"
} 

module "resource_group" {
  source = "../resource_group"
}

resource "azurerm_storage_account" "storage" {

  depends_on = ["module.resource_group"]

  name                     = "${lookup(var.storage, "name")}"
  resource_group_name      = "${module.global_variables.resource_group_name}"
  location                 = "${module.global_variables.location}"
  account_tier             = "${lookup(var.storage, "account_tier")}"
  account_replication_type = "${lookup(var.storage, "account_replication_type")}"

    tags {
      environment   = "${module.global_variables.environment}"
      Service       = "Kubernetes"
    }
}

