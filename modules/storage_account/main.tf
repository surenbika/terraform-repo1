resource "azurerm_storage_account" "storage" {

  #depends_on = ["module.mysql"]

  name                     = "${lookup(var.storage, "name")}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${lookup(var.storage, "account_tier")}"
  account_replication_type = "${lookup(var.storage, "account_replication_type")}"

    tags {
      environment   = "${var.environment}"
      Service       = "Kubernetes"
    }
}

