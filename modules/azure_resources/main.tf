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

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "TARRAFORM_PATH=pwd echo Azure Resource Script in action.... >> `$TARRAFORM_PATH`/test.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}