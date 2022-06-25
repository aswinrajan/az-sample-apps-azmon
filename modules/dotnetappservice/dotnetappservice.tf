resource "azurerm_resource_group" "dotnetrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "random_integer" "random" {
  min = 1
  max = 50000 
}

resource "azurerm_log_analytics_workspace" "appsvc-az-LAW" {
  name                = "appsvc-LAW"
  location            = azurerm_resource_group.dotnetrg.location
  resource_group_name = azurerm_resource_group.dotnetrg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "dotnet-ai" {
  name                = "${var.prefix}-ai"
  location            = azurerm_resource_group.dotnetrg.location
  resource_group_name = azurerm_resource_group.dotnetrg.name
  workspace_id        = azurerm_log_analytics_workspace.appsvc-az-LAW.id
  application_type    = "web"
}

resource "azurerm_service_plan" "dotnet-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = azurerm_resource_group.dotnetrg.name
  location            = azurerm_resource_group.dotnetrg.location
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "dotnet-webapp" {
  name                = random_integer.random.result
  resource_group_name = azurerm_resource_group.dotnetrg.name
  location            = azurerm_service_plan.dotnet-serviceplan.location
  service_plan_id     = azurerm_service_plan.dotnet-serviceplan.id
  site_config {
    
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.dotnet-ai.instrumentation_key
  }
}




