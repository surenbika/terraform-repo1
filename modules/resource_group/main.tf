resource "azurerm_resource_group" "rg" {

    #Resource Group
    name = "${var.resource_group_name}"
    location = "${var.location}"

    tags {
      environment   = "${var.environment}"
      Service       = "Kubernetes"
    }
}

output "name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "location" {
  value = "${azurerm_resource_group.rg.location}"
}