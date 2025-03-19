terraform {
  required_version = ">= 1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.91.0"
    }
  }
}

provider "aws" {
  profile = "Nathan-Dev"
  region  = "eu-west-2"
}