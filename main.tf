terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "aswinrajan"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "az-sample-apps-azmon"
    }
  }
}
resource "azurerm_resource_group" "appsvcRG" {
  name     = var.appsvcRG
  location = var.appsvcRGlocation
}


resource "azurerm_log_analytics_workspace" "appsvc-az-LAW" {
  name                = "appsvc-LAW"
  location            = var.appsvcRGlocation
  resource_group_name = var.appsvcRG
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


module "dotnetappservice" {
  source           = "./modules/dotnetappservice/"
  appsvcRG         = var.appsvcRG
  appsvcRGlocation = var.appsvcRGlocation
  law-id           = azurerm_log_analytics_workspace.appsvc-az-LAW.id
}

module "nodejsappservice" {
  source           = "./modules/nodejsappservice/"
  appsvcRG         = var.appsvcRG
  appsvcRGlocation = var.appsvcRGlocation
  law-id           = azurerm_log_analytics_workspace.appsvc-az-LAW.id
}