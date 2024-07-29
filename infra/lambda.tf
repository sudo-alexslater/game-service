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
// List Lobbies
///////////////////////////////////////////////////////////////
module "list_lobbies" {
  source = "./modules/lambda"
  name   = "list-lobbies"
  prefix = local.prefix
  environment_variables = {
    LOBBY_TABLE_NAME = aws_dynamodb_table.lobbies.name
  }
}
resource "aws_lambda_permission" "apigw_invoke_list_lobbies" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.list_lobbies.name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.core.execution_arn}/*/*"
}
resource "aws_iam_role_policy_attachment" "list_lobbies_dynamo" {
  role       = module.list_lobbies.role_name
  policy_arn = aws_iam_policy.lobby_dynamo_policy.arn
}

///////////////////////////////////////////////////////////////
// Create Lobby
///////////////////////////////////////////////////////////////
module "create_lobby" {
  source = "./modules/lambda"
  name   = "create-lobby"
  prefix = local.prefix
  environment_variables = {
    LOBBY_TABLE_NAME = aws_dynamodb_table.lobbies.name
  }
}
resource "aws_lambda_permission" "apigw_invoke_create_lobby" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.create_lobby.name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.core.execution_arn}/*/*"
}
resource "aws_iam_role_policy_attachment" "create_lobby_dynamo" {
  role       = module.create_lobby.role_name
  policy_arn = aws_iam_policy.lobby_dynamo_policy.arn
}
