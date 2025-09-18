variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
}

variable "web_app_service_plan_name" {
  description = "The name of app service plan"
  type        = string
}

variable "web_app_service_name" {
  description = "The name for the web app service name"
  type        = string
}

variable "web_app_service_slot_name" {
  description = "The name for the web app slot service name"
  type        = string
}

variable "web_app_service_node_version" {
  description = "Web app service node version"
  type        = string
}

variable "web_app_service_logs_level" {
  description = "level of logging"
  type        = string
}
