resource "random_integer" "random" {
  min = 1
  max = 50000 
}


resource "azurerm_application_insights" "nodejs-ai" {
  name                = "${var.prefix}-ai"
  location            = var.appsvcRGlocation
  resource_group_name = var.appsvcRG
  workspace_id        = var.law-id
  application_type    = "web"
}

resource "azurerm_service_plan" "nodejs-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = var.appsvcRG
  location            = var.appsvcRGlocation
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "nodejs-webapp" {
  name                = random_integer.random.result
  resource_group_name = var.appsvcRG
  location            = azurerm_service_plan.nodejs-serviceplan.location
  service_plan_id     = azurerm_service_plan.nodejs-serviceplan.id
  site_config {
    
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.nodejs-ai.instrumentation_key
  }
}




