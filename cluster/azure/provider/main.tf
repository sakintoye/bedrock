provider "azurerm" {
    version = "~>1.23.0"
}

provider "azuread" { 
  version = "~>0.2.0"
}

provider "random" {
  version = "~>2.1"
}

provider "null" {
  version = "~>2.0.0"
}

terraform {
  required_version = "~> 0.11.13"
}
