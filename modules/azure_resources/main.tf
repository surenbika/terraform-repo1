provider "azurerm" {
  alias           = "k8s_env"
  subscription_id = "${lookup(var.subscription_id, "value")}"
}