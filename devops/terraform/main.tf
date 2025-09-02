terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.77.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_location
}

# Service Plans
resource "azurerm_service_plan" "blue_plan" {
  name                = "blue-service-plan"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "F1" # Free Tier Plan
  os_type             = "Linux"
}

resource "azurerm_service_plan" "green_plan" {
  name                = "green-service-plan"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "F1" # Free Tier Plan
  os_type             = "Linux"
}

# Blue App Service
resource "azurerm_linux_web_app" "blue_app" {
  name                = var.blue_app_name
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.blue_plan.id

  site_config {
    always_on = false
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

# Green App Service
resource "azurerm_linux_web_app" "green_app" {
  name                = var.green_app_name
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.green_plan.id

  site_config {
    always_on = false
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

# Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "test_profile" {
  name                     = var.traffic_manager_name
  resource_group_name      = azurerm_resource_group.rg.name
  traffic_routing_method   = "Priority"

  dns_config {
    relative_name = var.traffic_manager_name
    ttl           = 60
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "blue_endpoint" {
  name                = "blue-endpoint"
  profile_id          = azurerm_traffic_manager_profile.test_profile.id
  target_resource_id  = azurerm_linux_web_app.blue_app.id # Direct link to App Service ID
  priority            = 1
  weight              = 100
}

resource "azurerm_traffic_manager_azure_endpoint" "green_endpoint" {
  name                = "green-endpoint"
  profile_id          = azurerm_traffic_manager_profile.test_profile.id
  target_resource_id  = azurerm_linux_web_app.green_app.id # Direct link to App Service ID
  priority            = 2
  weight              = 50
}

# # Blue Endpoint
# resource "azurerm_traffic_manager_external_endpoint" "blue_endpoint" {
#   name       = "blue-endpoint"
#   profile_id = azurerm_traffic_manager_profile.test_profile.id
#   target     = azurerm_linux_web_app.blue_app.default_hostname  # Default DNS for Blue App Service
#   priority   = 1
#   weight     = 100
# }

# # Green Endpoint
# resource "azurerm_traffic_manager_external_endpoint" "green_endpoint" {
#   name       = "green-endpoint"
#   profile_id = azurerm_traffic_manager_profile.test_profile.id
#   target     = azurerm_linux_web_app.green_app.default_hostname  # Default DNS for Green App Service
#   priority   = 2
#   weight     = 100
# }

output "blue_app_hostname" {
  value = azurerm_linux_web_app.blue_app.default_hostname
}

output "green_app_hostname" {
  value = azurerm_linux_web_app.green_app.default_hostname
}

output "active_app_environment" {
  value = var.active_app_environment
}

output "inactive_app_environment" {
  value = var.active_app_environment == "blue" ? "green" : "blue"
}
