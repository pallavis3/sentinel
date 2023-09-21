terraform {

  cloud {
    organization = "example-sentinel"

    workspaces {
      name = "learn-terraform-sentinel"
    }
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.54.0"
    }
  }
}

  provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "Sentinel-RG"
  location = "CentralUS"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Sentinel-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "snet" {
  name                 = "Sentinel-snet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "Sentinel-nic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "test"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "win" {
  name                = "win-machine"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  #computer_name       = "test-win"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "lin" {
  name              		  = "lin-machine"
  resource_group_name		  = azurerm_resource_group.RG.name
  location         	      = azurerm_resource_group.RG.location
  size               		  = "D2s_v3"
  admin_username     	          = "adminuser"
  disable_password_authentication = false
  admin_password                  = "P@$$w0rd1234!" 
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
