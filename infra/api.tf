resource "aws_api_gateway_rest_api" "core" {
  name           = "${local.prefix}-api"
  description    = "Quoting API"
  api_key_source = "HEADER"
  body           = data.template_file.core_oas.rendered

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "template_file" "core_oas" {
  template = file("${path.root}/../core/api/src/core.yml")

  vars = {
    healthcheck_arn = "${module.healthcheck.arn}"
    get_quote_arn   = "${module.get_quote.arn}"
    post_quote_arn  = "${module.post_quote.arn}"

    aws_region              = var.aws_region
    lambda_identity_timeout = var.lambda_identity_timeout
  }
}

resource "aws_api_gateway_deployment" "core" {
  rest_api_id = aws_api_gateway_rest_api.core.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.core.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "core" {
  deployment_id = aws_api_gateway_deployment.core.id
  rest_api_id   = aws_api_gateway_rest_api.core.id
  stage_name    = local.environment
}
