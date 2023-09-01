terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.71.0"
        }
    }
}

provider "azurerm" {
    features {}

    skip_provider_registration = true
}

resource "azurerm_resource_group" "azure_contact_list_resources" {
  name     = "contact-list-resources"
  location = "brazilsouth"
}

resource "azurerm_postgresql_server" "contact_list_db_server" {
  name                = "postgres-contact-list-db"
  location            = azurerm_resource_group.azure_contact_list_resources.location
  resource_group_name = azurerm_resource_group.azure_contact_list_resources.name

  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = "psqladmin"
  administrator_login_password = ""
  version                      = "11"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "contact_list_db" {
  name                = "contact_list_db"
  resource_group_name = azurerm_resource_group.azure_contact_list_resources.name
  server_name         = azurerm_postgresql_server.contact_list_db_server.name
  charset             = "UTF8"
  collation           = "pt-BR"
}
