terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.19.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }

  required_version = ">= 0.14"
}

