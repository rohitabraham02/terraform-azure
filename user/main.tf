terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "1.5.0"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }
}

provider "azuread" {
}

provider "azurerm" {
  
  features {}

}

data "azurerm_subscription" "current" {
}


resource "azuread_user" "user" {
  user_principal_name = "jdoed@vishwavijay143gmail.onmicrosoft.com"
  display_name        = "J. Doed"
  mail_nickname       = "jdoed"
  password            = "SecretP@sswd99!"
}



resource "azurerm_role_assignment" "example" {
  
  scope                =  data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.user.object_id
}