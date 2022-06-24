resource "azurerm_resource_group" "dotnetrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "random_integer" "random" {
  min = 1
  max = 50000 
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
  site_config {}
}

resource "azurerm_app_service_source_control" "dotnet-webapp-sourcecontrol" {
  app_id   = azurerm_windows_web_app.dotnet-webapp.id
  repo_url = "https://github.com/Azure-Samples/app-service-web-dotnet-get-started"
  branch   = "master"
}