
resource "aws_dynamodb_table" "quotes" {
  name         = "${local.prefix}-quotes"
  hash_key     = "quoteId"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "quoteId"
    type = "S"
  }
}
resource "aws_iam_policy" "quote_dynamo_policy" {
  name        = "${local.prefix}-quote-dynamo-policy"
  description = "Policy for Lambda to access DynamoDB"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.quotes.arn}"
    }
  ]
}
EOF
}
