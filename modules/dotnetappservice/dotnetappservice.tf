resource "random_integer" "random" {
  min = 1
  max = 50000 
}


resource "azurerm_application_insights" "dotnet-ai" {
  name                = "${var.prefix}-ai"
  location            = var.appsvcRGlocation
  resource_group_name = var.appsvcRG
  workspace_id        = var.law-id
  application_type    = "web"
  tags = {
    "hidden-link:/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.appsvcRG}/providers/Microsoft.Web/sites/${azurerm_service_plan.dotnet-serviceplan.name}" = "Resource"
  }
}

resource "azurerm_service_plan" "dotnet-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.appsvcRG
  location            = var.appsvcRGlocation
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "dotnet-webapp" {
  name                = random_integer.random.result
  resource_group_name = var.appsvcRG
  location            = azurerm_service_plan.dotnet-serviceplan.location
  service_plan_id     = azurerm_service_plan.dotnet-serviceplan.id
  site_config {
    
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.dotnet-ai.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.dotnet-ai.connection_string
  }
}




