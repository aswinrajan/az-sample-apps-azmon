terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "aswinrajan"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "az-tf-sample-apps-azmon"
    }
  }
}
resource "azurerm_resource_group" "appsvcrg" {
  name     = var.appsvcrg
  location = var.appsvcrglocation
}


resource "azurerm_log_analytics_workspace" "appsvc-az-law" {
  name                = "appsvc-LAW"
  location            = var.appsvcrglocation
  resource_group_name = var.appsvcrg
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.appsvcrg
  ]
}

data "azurerm_subscription" "current" {
}



module "dotnetappservice" {
  source                            = "./modules/dotnetappservice/"
  appsvcrg                          = var.appsvcrg
  appsvcrglocation                  = var.appsvcrglocation
  current_subscription_display_name = data.azurerm_subscription.current.display_name
  law-id                            = azurerm_log_analytics_workspace.appsvc-az-law.id
  depends_on = [
    azurerm_resource_group.appsvcrg,
    azurerm_log_analytics_workspace.appsvc-az-law
  ]
}

module "nodejsappservice" {
  source                            = "./modules/nodejsappservice/"
  appsvcrg                          = var.appsvcrg
  appsvcrglocation                  = var.appsvcrglocation
  current_subscription_display_name = data.azurerm_subscription.current.display_name
  law-id                            = azurerm_log_analytics_workspace.appsvc-az-law.id
  depends_on = [
    azurerm_resource_group.appsvcrg,
    azurerm_log_analytics_workspace.appsvc-az-law
  ]
}