terraform {
  required_version = "v1.5.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.52.0"
    }
  }
}

provider "aws" {
  profile = "Nathan-Dev"
  region  = "eu-west-2"
}