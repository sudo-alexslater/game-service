variable "cloudflare_api_token" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "lambda_identity_timeout" {
  type    = number
  default = 300
}

locals {
  service     = "gaming"
  environment = terraform.workspace
  account_id  = local.account_id_lookup[local.environment]
  account_id_lookup = {
    "sandbox" = "141887425967"
  }
  prefix = "${local.environment}-${local.service}"
}
