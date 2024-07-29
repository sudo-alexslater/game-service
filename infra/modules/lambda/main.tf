resource "aws_lambda_function" "this" {
  filename         = "${path.root}/dist/${var.name}.zip"
  function_name    = "${var.prefix}-${var.name}"
  role             = aws_iam_role.this.arn
  source_code_hash = data.archive_file.code.output_base64sha256
  handler          = "${var.name}.${var.handler_export_alias}"
  runtime          = var.runtime
  depends_on       = [aws_iam_role_policy_attachment.lambda_logging]
  environment {
    variables = var.environment_variables
  }
}
data "archive_file" "code" {
  type        = "zip"
  source_file = "${path.root}/../core/dist/${var.name}.js"
  output_path = "${path.root}/dist/${var.name}.zip"
}
