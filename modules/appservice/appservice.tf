resource "azurerm_resource_group" "mainrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_service_plan" "main-serviceplan" {
  name                = "${var.prefix}-appsp"
  resource_group_name = azurerm_resource_group.mainrg.name
  location            = azurerm_resource_group.mainrg.location
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "main-webapp" {
  name                = "${var.prefix}-webapp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main-serviceplan.location
  service_plan_id     = azurerm_service_plan.main-serviceplan.id
source_control {
    repo_url           = "https://github.com/Azure-Samples/app-service-web-dotnet-get-started"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
  site_config {}
}