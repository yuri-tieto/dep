# Configure the Azure provider
provider "azurerm" {
  version = "2.12.0"
  //use_msi         = true
  subscription_id = data.terraform_remote_state.main.outputs.subscription_id
  tenant_id       = data.terraform_remote_state.main.outputs.tenant_id

  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "project" {
  name     = "${data.terraform_remote_state.main.outputs.prefix}tf-project"
  location = "westeurope"
}
