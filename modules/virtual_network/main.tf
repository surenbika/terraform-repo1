provider "azurerm" {
  alias           = "k8s_env"
  subscription_id = "${var.subscription_id}"
}

resource "azurerm_virtual_network" "virtual_network" {

  #depends_on = ["module.logs"]

  name                = "${lookup(var.virtual_network, "name")}"
  address_space       = ["${lookup(var.virtual_network, "address_space")}"]
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  subnet {
    name           = "${lookup(var.subnet, "name")}"
    address_prefix = "10.90.39.0/24" #["${lookup(var.subnet, "address_space")}"]
  }

  tags {
    environment   = "${var.environment}"
    Service       = "Kubernetes"
  }

  provider = "azurerm.k8s_env"
}

output "name" {
  value = "${azurerm_virtual_network.virtual_network.name}"
}