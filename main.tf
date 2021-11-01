# Configure Terraform to set the required AzureRM provider
# version and features{} block.
# Ref URLs:
#  https://www.youtube.com/watch?v=5pJxM1O4bys&t=16s
#  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources
#  https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/terraform-module-caf-enterprise-scale
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Enterprise-Scale"
}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.0.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

}