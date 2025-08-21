provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_location
}

# App Service Plans
resource "azurerm_app_service_plan" "blue_plan" {
  name                = "blue-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service_plan" "green_plan" {
  name                = "green-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

# Blue App Service
resource "azurerm_app_service" "blue_app" {
  name                = var.blue_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.blue_plan.id
}

# Green App Service
resource "azurerm_app_service" "green_app" {
  name                = var.green_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.green_plan.id
}


resource "azurerm_traffic_manager_endpoint" "blue_endpoint" {
  name                    = "blue-endpoint"
  profile_name            = azurerm_traffic_manager_profile.traffic_manager.name
  resource_group_name     = azurerm_resource_group.rg.name
  type                    = "azureEndpoints"
  target_resource_id      = azurerm_app_service.blue_app.id
  priority                = (var.active_app_environment == "blue" ? 1 : 2)
}

resource "azurerm_traffic_manager_endpoint" "green_endpoint" {
  name                    = "green-endpoint"
  profile_name            = azurerm_traffic_manager_profile.traffic_manager.name
  resource_group_name     = azurerm_resource_group.rg.name
  type                    = "azureEndpoints"
  target_resource_id      = azurerm_app_service.green_app.id
  priority                = (var.active_app_environment == "green" ? 1 : 2)
}

# Output variables

output "blue_app_domain" {
  value = azurerm_app_service.blue_app.default_site_hostname
}

output "green_app_domain" {
  value = azurerm_app_service.green_app.default_site_hostname
}

output "active_app_environment" {
  value = var.active_app_environment
}

output "inactive_app_environment" {
  value = var.active_app_environment == "blue" ? "green" : "blue"
}