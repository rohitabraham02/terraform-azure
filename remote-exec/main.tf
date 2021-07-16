terraform {
 
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }
}


provider "azurerm" {  
features {}
}

resource "azurerm_resource_group" "example" {
 
  name     = "example-resources14"
  location = "West Europe"

 
provisioner "file" {
  source      = "install.sh"
  destination = "/home/azureuser/install.sh"

  connection {
    type        = "ssh"
    user        = "azureuser"
    host        = "13.68.140.156"
    agent       = true
  }
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/azureuser/install.sh",
      "/home/azureuser/install.sh > /home/azureuser/install",
    ]

  connection {
    type        = "ssh"
    user        = "azureuser"
    host        = "13.68.140.156"
    agent       = true
  }
  }
} 
