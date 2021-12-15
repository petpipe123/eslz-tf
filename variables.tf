# Ref URLs
#   https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes


# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "pp-es"
}

variable "root_name" {
  type    = string
  default = "Custom PP ESLZ"
}

variable "deploy_management_resources" {
  type    = bool
  default = false
}

variable "log_retention_in_days" {
  type    = number
  default = 10
}

variable "security_alerts_email_address" {
  type    = string
  default = "petpipe123@gmail.com" # Replace this value with your own email address.
}

variable "management_resources_location" {
  type    = string
  default = "centralus"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_management_resources_custom"
  }
}