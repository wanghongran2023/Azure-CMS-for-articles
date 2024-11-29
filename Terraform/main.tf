terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

# provider "azuread" {
#  tenant_id       = var.provider_credentials.tenant_id
#  client_id       = var.provider_credentials.sp_client_id
#  client_secret   = var.provider_credentials.sp_client_secret
# }

provider "azurerm" {
  subscription_id = var.provider_credentials.subscription_id
  tenant_id       = var.provider_credentials.tenant_id
  client_id       = var.provider_credentials.sp_client_id
  client_secret   = var.provider_credentials.sp_client_secret
  features {}
}

resource "azurerm_resource_group" "cms" {
  name     = var.resource_group_config.name
  location = var.resource_group_config.location
}

resource "azurerm_mssql_server" "cms_dbserver" {
  name                         = var.db_server_config.name
  resource_group_name          = azurerm_resource_group.cms.name
  location                     = azurerm_resource_group.cms.location
  version                      = "12.0"
  administrator_login          = var.db_server_config.user
  administrator_login_password = var.db_server_config.password

  depends_on = [azurerm_resource_group.cms]
}

resource "azurerm_mssql_database" "cms_db" {
  name                = var.db_config.name
  server_id           = azurerm_mssql_server.cms_dbserver.id
  sku_name            = "Basic"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 2
  min_capacity        = 0.5
  zone_redundant      = false
  auto_pause_delay_in_minutes = 60
  depends_on = [azurerm_mssql_server.cms_dbserver]
}

resource "azurerm_mssql_firewall_rule" "allow_azure_ips" {
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.cms_dbserver.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_all_ips" {
  name                = "AllowAllIPs"
  server_id           = azurerm_mssql_server.cms_dbserver.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_storage_account" "images_storage_account" {
  name                     = var.storage_account_config.name
  resource_group_name      = azurerm_resource_group.cms.name
  location                 = azurerm_resource_group.cms.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_config.name
  storage_account_name  = azurerm_storage_account.images_storage_account.name
  container_access_type = "container"
}

output "storage_key" {
  value = azurerm_storage_account.images_storage_account.primary_access_key
  sensitive = true
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "python-app-service-plan"
  location            = azurerm_resource_group.cms.location
  resource_group_name = azurerm_resource_group.cms.name
  sku {
    tier = "PremiumV3"
    size = "P0v3"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                  = var.app_config.name
  location              = azurerm_resource_group.cms.location
  resource_group_name   = azurerm_resource_group.cms.name
  service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
  }
  app_settings = {
    "WEBSITE_STACK"         = "python"
    "PYTHON_VERSION"        = "3.9"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }
}

resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/wanghongran2023/Azure-CMS-for-articles"
  branch             = "main"
  use_manual_integration = false
  use_mercurial      = false
}


# resource "azuread_application" "app_registration" {
#  display_name               = var.app_config.name
# }

# resource "azuread_application_password" "app_secret" {
#  application_id      = azuread_application.app_registration.id
#  end_date                   = "2025-12-31T23:59:59Z"
# }


