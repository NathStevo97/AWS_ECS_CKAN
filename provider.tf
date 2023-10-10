terraform {
  required_version = "=v1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.20.0"
    }
  }
}

provider "aws" {
  profile = "Nathan-Dev"
  region  = "eu-west-2"
}