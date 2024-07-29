///////////////////////////////////////////////////////////////
// Healthcheck
///////////////////////////////////////////////////////////////
module "healthcheck" {
  source = "./modules/lambda"
  name   = "healthcheck"
  prefix = local.prefix
}
resource "aws_lambda_permission" "apigw_invoke_healthcheck" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.healthcheck.name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.core.execution_arn}/*/*"
}

///////////////////////////////////////////////////////////////
// Get Quote
///////////////////////////////////////////////////////////////
module "get_quote" {
  source = "./modules/lambda"
  name   = "get-quote"
  prefix = local.prefix
  environment_variables = {
    QUOTE_TABLE_NAME = aws_dynamodb_table.quotes.name
  }
}
resource "aws_lambda_permission" "apigw_invoke_get_quote" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.get_quote.name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.core.execution_arn}/*/*"
}
resource "aws_iam_role_policy_attachment" "get_quote_dynamo" {
  role       = module.get_quote.role_name
  policy_arn = aws_iam_policy.quote_dynamo_policy.arn
}

///////////////////////////////////////////////////////////////
// Post Quote
///////////////////////////////////////////////////////////////
module "post_quote" {
  source = "./modules/lambda"
  name   = "post-quote"
  prefix = local.prefix
  environment_variables = {
    QUOTE_TABLE_NAME = aws_dynamodb_table.quotes.name
  }
}
resource "aws_lambda_permission" "apigw_invoke_post_quote" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.post_quote.name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.core.execution_arn}/*/*"
}
resource "aws_iam_role_policy_attachment" "post_quote_dynamo" {
  role       = module.post_quote.role_name
  policy_arn = aws_iam_policy.quote_dynamo_policy.arn
}
