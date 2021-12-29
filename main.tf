terraform {
  required_providers {
    azurerm = ">= 1.36.0"
  }
}
provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "service" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

  enforce_private_link_service_network_policies = true
}

resource "azurerm_subnet" "endpoint" {
  name                 = var.endpoint
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_public_ip" "example" {
  name                = var.public_IP_name
  sku                 = "Standard"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = var.load_balancer
  sku                 = "Standard"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.example.name
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_private_link_service" "example" {
  name                = var.private_link
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  nat_ip_configuration {
    name      = azurerm_public_ip.example.name
    primary   = true
    subnet_id = azurerm_subnet.service.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.example.frontend_ip_configuration.0.id,
  ]
}

resource "azurerm_private_endpoint" "example" {
  name                = var.private_endpoint
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = var.private_service_connection
    private_connection_resource_id = azurerm_private_link_service.example.id
    is_manual_connection           = false
  }
}