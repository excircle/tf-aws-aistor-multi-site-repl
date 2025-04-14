terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

terraform {
  backend "s3" {}
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}