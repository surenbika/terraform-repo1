module "storage" {
  source = "../storage_account"

  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  environment            = "${var.environment}"
}

resource "azurerm_log_analytics_workspace" "logs" {

  depends_on = ["module.storage"]

  name                = "${lookup(var.logs, "name")}" 
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  sku                 = "${lookup(var.logs, "sku")}"
}

resource "azurerm_log_analytics_solution" "solution" {

  depends_on = ["module.storage"]

  solution_name         = "${lookup(var.logs_solution, "solution_name")}" 
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.logs.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.logs.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}