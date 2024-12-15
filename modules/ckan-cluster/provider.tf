terraform {
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.63.0"
    }
  }
}

provider "aws" {
  profile = "Nathan-Dev"
  region  = "eu-west-2"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}