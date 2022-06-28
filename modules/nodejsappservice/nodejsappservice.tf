resource "random_integer" "random" {
  min = 1
  max = 50000 
}


resource "azurerm_application_insights" "nodejs-ai" {
  name                = "${var.prefix}-ai"
  location            = var.appsvcrglocation
  resource_group_name = var.appsvcrg
  workspace_id        = var.law-id
  application_type    = "web"
  tags = {
    "hidden-link:/subscriptions/${var.current_subscription_display_name}/resourceGroups/${var.appsvcrg}/providers/Microsoft.Web/sites/${random_integer.random.result}" = "Resource"
  }
}

resource "azurerm_service_plan" "nodejs-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.appsvcrg
  location            = var.appsvcrglocation
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "nodejs-webapp" {
  name                = random_integer.random.result
  resource_group_name = var.appsvcrg
  location            = azurerm_service_plan.nodejs-serviceplan.location
  service_plan_id     = azurerm_service_plan.nodejs-serviceplan.id
  site_config {
    
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.nodejs-ai.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.nodejs-ai.connection_string
  }
}




