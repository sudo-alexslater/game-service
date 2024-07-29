terraform {
  backend "s3" {
    bucket         = "141887425967-tfstate"
    key            = "gaming.tfstate"
    dynamodb_table = "terraform-state-lock"
    region         = "eu-west-1"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
