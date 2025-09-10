variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
}

variable "blue_app_name" {
  description = "The name for the blue app service"
  type        = string
}

variable "green_app_name" {
  description = "The name for the green app service"
  type        = string
}

variable "traffic_manager_name" {
  description = "DNS name for the Traffic Manager"
  type        = string
}

variable "active_app_environment" {
  description = "Determines the currently live environment (blue or green)"
  type        = string
}

variable "dns_zone_name" {
  description = "The DNS zone name"
  type        = string
  default     = "blue-green-tm"
}

variable "active_app" {
  description = "The active application environment (blue/green)"
  type        = string
  default     = "example.com"
}