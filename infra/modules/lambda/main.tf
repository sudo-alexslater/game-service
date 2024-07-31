resource "aws_lambda_function" "this" {
  filename         = data.archive_file.code.output_path
  function_name    = "${var.prefix}-${var.name}"
  role             = aws_iam_role.this.arn
  source_code_hash = data.archive_file.code.output_base64sha256
  handler          = "${var.name}.${var.handler_export_alias}"
  runtime          = var.runtime
  environment {
    variables = var.environment_variables
  }
  depends_on = [aws_iam_role_policy_attachment.lambda_logging]
}
data "archive_file" "code" {
  type        = "zip"
  source_file = "${path.root}/../core/dist/lambdas/${var.name}.js"
  output_path = "${path.root}/dist/${var.name}.zip"
}
