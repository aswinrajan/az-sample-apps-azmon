resource "random_integer" "random" {
  min = 1
  max = 50000 
}


resource "azurerm_application_insights" "dotnet-ai" {
  name                = "${var.prefix}-ai"
  location            = var.appsvcrglocation
  resource_group_name = var.appsvcrg
  workspace_id        = var.law-id
  application_type    = "web"
  tags = {
    "hidden-link:/subscriptions/${var.current_subscription_display_name}/resourceGroups/${var.appsvcRG}/providers/Microsoft.Web/sites/${random_integer.random.result}" = "Resource"
  }
}

resource "azurerm_service_plan" "dotnet-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.appsvcrg
  location            = var.appsvcrglocation
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "dotnet-webapp" {
  name                = random_integer.random.result
  resource_group_name = var.appsvcrg
  location            = azurerm_service_plan.dotnet-serviceplan.location
  service_plan_id     = azurerm_service_plan.dotnet-serviceplan.id
  site_config {
    
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.dotnet-ai.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.dotnet-ai.connection_string
  }
}




