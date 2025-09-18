terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.77.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "TerraformStateRG"
    storage_account_name = "tfstatea9e1466d"
    container_name       = "tfstate"
    key                  = "nestjs-prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_location
}

resource "azurerm_service_plan" "nestjs_cicd_app_plan" {
  name                = var.web_app_service_plan_name 
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "nestjs_cicd_app" {
  name                = var.web_app_service_name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.nestjs_cicd_app_plan.id
  depends_on = [azurerm_service_plan.nestjs_cicd_app_plan]

  site_config {
    always_on = false
    application_stack {
      node_version = var.web_app_service_node_version
    }
  }

  logs {
    detailed_error_messages = true
    application_logs {
      file_system_level = var.web_app_service_logs_level
    }
  }

  app_settings = {
    "PORT": "3000"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
  }
}

resource "azurerm_app_service_slot" "nestjs_cicd_app_slot" {
  name                = var.web_app_service_slot_name
  app_service_name    = azurerm_linux_web_app.nestjs_cicd_app.name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.nestjs_cicd_app_plan.id
  depends_on = [azurerm_linux_web_app.nestjs_cicd_app]

  site_config {
    always_on = false
  }

  app_settings = {
    "PORT": "3000"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
  }
}