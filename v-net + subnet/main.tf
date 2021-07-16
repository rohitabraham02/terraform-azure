terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.64.0"
    }
  }
}


provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "resourceGroup" {
  
  name     = "dev-resource-group"
  location = "West Europe"
  
}

resource "azurerm_virtual_network" "Vnet" {
  name                = "Dev-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_subnet" "SubNet1" {
  name                 = "SubNet1"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "SubNet2" {
  name                 = "SubNet2"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "network_security_group_dev"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  security_rule {
    name                       = "allowtcp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.SubNet1.id
  network_security_group_id = azurerm_network_security_group.example.id
}

