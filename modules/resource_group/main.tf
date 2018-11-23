module "global_variables" {
    source = "../global_variables"
} 

resource "azurerm_resource_group" "rg" {

    #Resource Group
    name = "${module.global_variables.resource_group_name}" #"${var.resource_group_name}"
    location = "${module.global_variables.location}" #"${var.location}"

    tags {
      environment   = "${module.global_variables.environment}"
      Service       = "Kubernetes"
    }
}

output "name" {
  value = "${azurerm_resource_group.rg.name}"
}

#output "location" {
#  value = "${azurerm_resource_group.rg.location}"
#}