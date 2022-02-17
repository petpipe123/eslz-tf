# Configure Terraform to set the required AzureRM provider
# version and features{} block.
# Ref URLs:
#  https://www.youtube.com/watch?v=5pJxM1O4bys&t=16s
#  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources
#  https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/terraform-module-caf-enterprise-scale
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes

# Customization
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/[Variables]-custom_landing_zones
# https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions
#  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/archetype_definitions/archetype_definition_es_root.tmpl.json

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.2"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

# Do NOT deploy demo landing zones:
  deploy_demo_landing_zones = false

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  # leverage variables:
  deploy_management_resources    = var.deploy_management_resources
  # Use settings.management.tf file settings:
  configure_management_resources = local.configure_management_resources

# This is where Main.tf will continuously evolve with the archetype definition json files that represent Optimistic and Pessimistic type LZs
# notice the archectype_id and how two different json files will have different params with values specified
  custom_landing_zones = {

    "${var.root_id}-avd" = {
      display_name               = "${upper(var.root_id)} AVD"
      parent_management_group_id = "${var.root_id}-platform"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "archetype_g_avd"
        parameters     = {}
        access_control = {}
      }
    }

    "${var.root_id}-g-optimistic" = {
      display_name               = "${upper(var.root_id)} Optimistic"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "archetype_g_optimistic"
        parameters     = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["centralus",]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["centralus",]
          }          
        }
        access_control = {}
      }
    }

    "${var.root_id}-g-pessimistic" = {
      display_name               = "${upper(var.root_id)} Pessimistic"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "archetype_g_pessimistic"
        parameters     = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["centralus",]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["centralus",]
          }          
        }
        access_control = {}
      }
    }
    
  }

}