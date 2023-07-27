terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.65.1"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = "11e07d93-b7de-44c1-b006-7218b5fb3180"
  client_id       = "b30bfd9a-8e64-4c5a-ac79-c166d9ae713c"
  client_secret   = "mit8Q~qmWXTwifGCRrGggw0m97aJnXNLHwVdTaaZ"
  tenant_id       = "30bf9f37-d550-4878-9494-1041656caf27"
}

resource "azurerm_resource_group" "rg" {
    name = "${var.org}-${var.env}-${var.app}-rg"
    location = var.rglocation
    
}    

locals {
  tags = {
    environment = "dev"
    department = "Infra & Apps"
    Owner = "nc"
    Application = "CSP"
    CreatedOn = "26JUL2023"
  }
}

resource "azurerm_log_analytics_workspace" "logs" {
    name = "${var.org}-${var.env}-${var.app}-logs"
    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    sku = "PerGB2018"
    retention_in_days = 30
    depends_on = [ azurerm_mssql_database.db ]
    tags = local.tags
  
}

resource "azurerm_application_insights" "appi" {
    name = "${var.org}-${var.env}-${var.app}-api-appi"
    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    workspace_id = azurerm_log_analytics_workspace.logs.id
    application_type = "web"
    depends_on = [ azurerm_mssql_database.db ]

    tags = local.tags

  
}

resource "azurerm_application_insights" "webappi" {
    name = "${var.org}-${var.env}-${var.app}-web-appi"
    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    workspace_id = azurerm_log_analytics_workspace.logs.id
    application_type = "web"
    tags = local.tags
  
}
resource "azurerm_app_service_plan" "plantest" {
    name = "${var.org}-${var.env}-${var.app}-plan"

    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    tags = local.tags

    sku {
      size = lookup(var.sku_to_size_and_tier[var.sku_name], "size", "")
      tier = lookup(var.sku_to_size_and_tier[var.sku_name], "tier", "")
    }
    
  
}

resource "azurerm_app_service" "webapp" {
    name = "${var.org}-${var.env}-${var.app}-web-api"
    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.plantest.id
    depends_on = [ azurerm_app_service_plan.plantest ]

    site_config {
      always_on = true
    }
    app_settings = {
        "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.webappi.instrumentation_key
    }
    tags = local.tags
  
}

resource "azurerm_mssql_server" "serverdemo" {
  name = "${var.org}-${var.env}-${var.app}-server"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  version = "12.0"
  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_login_password
  tags = local.tags
}

resource "azurerm_mssql_database" "db" {
  name = "${var.org}-${var.env}-${var.app}-db"
  server_id = azurerm_mssql_server.serverdemo.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 250
  depends_on = [ azurerm_mssql_server.serverdemo ]
  tags = local.tags

}


resource "azurerm_app_service" "apiapp" {
    name = "${var.org}-${var.env}-${var.app}-api-app"
    location = var.rglocation
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.plantest.id
    depends_on = [ azurerm_mssql_database.db ]

    site_config {
      always_on = true
    }
    connection_string {
      name = "MyDbConnection"
      type = "SQLServer"
      value = "Server=tcp:${azurerm_mssql_server.serverdemo.fully_qualified_domain_name}, 1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.serverdemo.administrator_login};Password=${azurerm_mssql_server.serverdemo.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    }
    app_settings = {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appi.instrumentation_key
    }

    tags = local.tags
    }

resource "azurerm_storage_account" "sa" {
  name = "${var.org}${var.env}${var.app}sa"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.rglocation
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.tags
  depends_on = [ azurerm_resource_group.rg ]
  blob_properties {
    cors_rule {
      allowed_origins = ["*"]
      allowed_methods = ["GET", "POST", "DELETE", "HEAD", "MERGE", "OPTIONS", "PUT", "PATCH"]
      allowed_headers = ["*"]
      exposed_headers = ["*"]
      max_age_in_seconds = 86400
    }
  }
      
}

resource "azurerm_key_vault" "testkey" {
  name = "${var.org}-${var.env}-${var.app}-key-valut"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.rglocation
  enabled_for_disk_encryption = true
  tenant_id = var.tenant_id
  soft_delete_retention_days = 7
  depends_on = [ azurerm_resource_group.rg ]
  sku_name = "standard"
  tags = local.tags
  
}
resource "azurerm_key_vault_access_policy" "terrafrom_demo" {
    key_vault_id = azurerm_key_vault.testkey.id
    tenant_id = var.tenant_id
    object_id = var.object_id
    application_id = var.client_id
    depends_on = [ azurerm_key_vault.testkey ]

    key_permissions = [
        "Get",
        "List",
    ]
    secret_permissions = [
        "Get",
        "List"
    ]
  
}

resource "azurerm_key_vault_secret" "connection_string" {
    name = "DatabaseConnectionString"
    value = "Server=tcp:${azurerm_mssql_server.serverdemo.fully_qualified_domain_name}, 1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.serverdemo.administrator_login};Password=${azurerm_mssql_server.serverdemo.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    key_vault_id = azurerm_key_vault.testkey.id
  
}
resource "azurerm_key_vault_secret" "instrumentation_key1" {
    name = "Instrumentationkey"
    value = azurerm_application_insights.webappi.instrumentation_key
    key_vault_id = azurerm_key_vault.testkey.id
  
}
/*resource "azurerm_key_vault_secret" "instrumentation_key2" {
    name = "Instrumentationkey"
    value = azurerm_application_insights.appi.instrumentation_key
    key_vault_id = azurerm_key_vault.testkey.id
  
}*/


output "azurerm_key_vault_secret" {
    value = azurerm_key_vault_secret.connection_string.id
    sensitive = true
  
}
output "azurerm_application_insights" {
    value = azurerm_application_insights.webappi.instrumentation_key
    sensitive = true
  
}


