module "global_variables" {
    source = "../global_variables"
} 

module "resource_group" {
  source = "../resource_group"
}

resource "azurerm_log_analytics_workspace" "logs" {

  depends_on = ["module.resource_group"]

  name                = "${lookup(var.logs, "name")}" 
  location            = "${module.global_variables.location}"
  resource_group_name = "${module.global_variables.resource_group_name}"
  sku                 = "${lookup(var.logs, "sku")}"
}

resource "azurerm_log_analytics_solution" "logs" {
  
  depends_on = ["module.resource_group", "azurerm_log_analytics_workspace.logs"]

  solution_name         = "${lookup(var.logs_solution, "solution_name")}" 
  location              = "${module.global_variables.location}"
  resource_group_name   = "${module.global_variables.resource_group_name}"
  workspace_resource_id = "${lookup(var.logs_solution, "workspace_resource_id")}"
  workspace_name        = "${lookup(var.logs_solution, "workspace_name")}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}