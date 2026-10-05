#stacks/app/main.tf

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "terraform_remote_state" "nettverk" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.nettverk_state_key
    use_azuread_auth     = true
  }
}

locals {
  base_name = lower(format("%s-%s-%s", var.project, var.environment, var.shortname))

  tags = {
    environment = var.environment
    owner       = var.shortname
    project     = var.project
    stack       = "app"
    managedby   = "terraform"
  }

  subnet_id = data.terraform_remote_state.nettverk.outputs.subnet_ids[var.vm_subnet_key]
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-app-%s", local.base_name)
  location = var.location
  tags     = local.tags
}

module "compute" {
  source = "../../modules/compute"

  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  base_name      = local.base_name
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  tags           = local.tags


  subnet_id = local.subnet_id
}