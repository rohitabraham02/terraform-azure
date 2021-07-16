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

data "azurerm_resource_group" "main" {
  name = "dev-resource-group"
}   


data "azurerm_virtual_network" "main" {
  name                = "Dev-network"
  resource_group_name = data.azurerm_resource_group.main.name
}


data "azurerm_subnet" "main" {
  name                 = "SubNet1"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}


resource "azurerm_public_ip" "main" {
  name                = "my-ip-address"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}



resource "azurerm_network_interface" "main" {
  name                = "my-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "my-vm-terraform"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "XXX"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
}