terraform {
  required_version = ">= 1.9.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.5"
    }
  }
}
