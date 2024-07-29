locals {
  domain_name = "alexslater.io"
  subdomain   = "quote"
  full_domain = "${local.subdomain}.${local.domain_name}"
}

resource "aws_api_gateway_domain_name" "alexslaterio" {
  regional_certificate_arn = module.acm.acm_certificate_arn
  domain_name              = local.full_domain
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "cloudflare_zone" "alexslaterio" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = local.full_domain
  zone_id     = data.cloudflare_zone.alexslaterio.id

  # subject_alternative_names = [
  #   
  # ]

  create_route53_records  = false
  validation_method       = "DNS"
  validation_record_fqdns = cloudflare_record.validation[*].hostname

  tags = {
    Name = local.domain_name
  }
}

resource "cloudflare_record" "validation" {
  count = length(module.acm.distinct_domain_names)

  zone_id = data.cloudflare_zone.alexslaterio.id
  name    = element(module.acm.validation_domains, count.index)["resource_record_name"]
  type    = element(module.acm.validation_domains, count.index)["resource_record_type"]
  value   = trimsuffix(element(module.acm.validation_domains, count.index)["resource_record_value"], ".")
  ttl     = 60
  proxied = false

  allow_overwrite = true
}

resource "cloudflare_record" "apialexslaterio" {
  zone_id         = data.cloudflare_zone.alexslaterio.id
  name            = local.subdomain
  type            = "CNAME"
  value           = aws_api_gateway_domain_name.alexslaterio.regional_domain_name
  ttl             = 1
  proxied         = true
  allow_overwrite = true
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.core.id
  stage_name  = aws_api_gateway_stage.core.stage_name
  domain_name = aws_api_gateway_domain_name.alexslaterio.domain_name
}

