terraform {
  backend "remote" {
    organization = "hashicorp-team-da-beta"

    workspaces {
      name = "azure-cluster"
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11.0"
    }

    hcp = {
      source  = "hashicorp/hcp"
      version = "0.59.0"
    }

    azuread = {
      source = "hashicorp/azuread"
      version = "2.39.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "hcp" {
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}