module "resource_group" {
  source = "../resource_group"

  resource_group_name     = "${var.resource_group_name}"
  location                = "${var.location}"
  environment             = "${var.environment}"

}

resource "azurerm_mysql_server" "mysql" {

  depends_on = ["module.resource_group"]

  name                = "${lookup(var.mysql, "name")}"
  location            = "${var.location}" #"${module.global_variables.location}" #"${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${var.resource_group_name}" #"${module.global_variables.resource_group_name}" #"${data.azurerm_resource_group.rg.name}"
   
  sku {
    name     = "${lookup(var.sku, "name")}"
    capacity = "${lookup(var.sku, "capacity")}"
    tier     = "${lookup(var.sku, "tier")}"
    family   = "${lookup(var.sku, "family")}"
  }

  storage_profile {
    storage_mb            = "${lookup(var.storage_profile, "storage_mb")}"
    backup_retention_days = "${lookup(var.storage_profile, "backup_retention_days")}"
    geo_redundant_backup  = "${lookup(var.storage_profile, "geo_redundant_backup")}"
  }

  administrator_login          = "${lookup(var.mysql, "user")}"
  administrator_login_password = "${var.password}"
  version                      = "${lookup(var.mysql, "version")}"
  ssl_enforcement              = "${lookup(var.mysql, "ssl_enforcement")}"

  tags {
      environment   = "${var.environment}" #"${module.global_variables.environment}"
      Service       = "Kubernetes"
  }
}

resource "azurerm_mysql_database" "mysql" {

  #depends_on = ["module.resource_group"]

  name                = "${lookup(var.mysql, "database_name")}"
  resource_group_name = "${var.resource_group_name}" #"${module.global_variables.resource_group_name}" #"${data.azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "${var.charset}"
  collation           = "${var.collation}"
}

resource "azurerm_mysql_firewall_rule" "mysql" {

  #depends_on = ["module.resource_group", "azurerm_mysql_server.mysql"]

  name                = "${lookup(var.mysql, "name")}"
  resource_group_name = "${var.resource_group_name}" #"${module.global_variables.resource_group_name}" #"${data.azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  start_ip_address    = "${var.start_ip_address}"
  end_ip_address      = "${var.end_ip_address}" 
}