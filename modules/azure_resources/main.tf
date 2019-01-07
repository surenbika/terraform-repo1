module "aks_env_rg" {
  source = "../resource_group"

  resource_group_name     = "${var.resource_group_name}" #"${lookup(var.resource_group_name, "value")}"
  location                = "${var.location}" #"${lookup(var.location, "value")}"
  environment             = "${var.environment}" #"${lookup(var.environment, "value")}"

}

module "aks_env_mysql" {
  source = "../mysql"

  resource_group_name     = "${var.resource_group_name}"
  location                = "${var.location}"
  environment             = "${var.environment}"
  password                = "${var.password}"

  charset                 = "${var.charset}"
  collation               = "${var.collation}"

  start_ip_address        = "${var.start_ip_address}"
  end_ip_address          = "${var.end_ip_address}" 
}

module "aks_env_logs" {
  source = "../oms_loganalytics"

  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  environment            = "${var.environment}" 
}

module "aks_env_storage" {
  source = "../storage_account"

  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  environment            = "${var.environment}" 
}

module "aks_env_vnet" {
  source = "../virtual_network"

  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  environment            = "${var.environment}"
  subscription_id        = "${var.subscription_id}" 
}

module "aks_env_keyvault" {
  source = "../keyvault"

  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  environment            = "${var.environment}"
  subscription_id        = "${var.subscription_id}" 
  tenant_id              = "${var.tenant_id}"
  object_id              = "${var.object_id}" 
}