resource "aws_api_gateway_rest_api" "core" {
  name           = "${local.prefix}-api"
  description    = "Gaming API"
  api_key_source = "HEADER"
  body           = data.template_file.core_oas.rendered

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "template_file" "core_oas" {
  template = file("${path.root}/../core/api/core.yml")

  vars = {
    healthcheck_arn  = "${module.healthcheck.arn}"
    list_lobbies_arn = "${module.list_lobbies.arn}"
    create_lobby_arn = "${module.create_lobby.arn}"

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
