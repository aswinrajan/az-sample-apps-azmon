resource "azurerm_resource_group" "mainrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}