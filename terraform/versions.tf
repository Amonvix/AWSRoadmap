# terraform/versions.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # ou a versão mais recente compatível
    }
  }
}

provider "aws" {
  region = "us-east-1" # Escolha uma região, 'us-east-1' geralmente tem o melhor Free Tier.
}
