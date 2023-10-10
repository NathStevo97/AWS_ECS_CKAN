provider "aws" {
  profile = "Nathan-Dev"
  region  = "eu-west-2"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}