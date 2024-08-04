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
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
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

provider "docker" {
  registry_auth {
    address  = local.ecr_address
    password = data.aws_ecr_authorization_token.this.password
    username = data.aws_ecr_authorization_token.this.user_name
  }
}

locals {
  ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.this.name)
}

