
resource "aws_dynamodb_table" "lobbies" {
  name         = "${local.prefix}-lobbies"
  hash_key     = "lobbyId"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "lobbyId"
    type = "S"
  }
}
resource "aws_iam_policy" "lobby_dynamo_policy" {
  name        = "${local.prefix}-lobby-dynamo-policy"
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
      "Resource": "${aws_dynamodb_table.lobbies.arn}"
    }
  ]
}
EOF
}
