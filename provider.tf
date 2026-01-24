terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "chetan-edu-tf-state-3tier-iac"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Owner       = "Chetan Pardeshi"
      Environment = "Practice-Sandbox"
    }
  }
}