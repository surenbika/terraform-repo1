module "global_variables" {
    source = "../Module_Global_Variables"
} 

resource "azurerm_resource_group" "rg" {

    #Resource Group
    name = "${var.resource_group}"
    location = "${var.location}"
}