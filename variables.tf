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
