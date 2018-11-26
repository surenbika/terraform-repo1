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

resource "azurerm_virtual_network" "virtual_network" {

  depends_on = ["module.resource_group"]

  name                = "${lookup(var.virtual_network, "name")}"
  address_space       = ["${lookup(var.virtual_network, "address_space")}"]
  location            = "${module.global_variables.location}"
  resource_group_name = "${module.global_variables.resource_group_name}"

  subnet {
    name           = "${lookup(var.subnet, "name")}"
    address_prefix = "10.90.39.0/24" #["${lookup(var.subnet, "address_space")}"]
  }

  tags {
    environment   = "${module.global_variables.environment}"
    Service       = "Kubernetes"
  }

  provider = "azurerm.k8s_env"
}

output "name" {
  value = "${azurerm_virtual_network.virtual_network.name}"
}