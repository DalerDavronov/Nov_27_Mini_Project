terraform {
  cloud {
    organization = "Ziyotek_Terraform_Class_Summer_Cloud"

    workspaces {
      name = "Nov_27_Mini_Project"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}