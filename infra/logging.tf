# --------------------------------------------------------------
# --- LOGGING ---
# --------------------------------------------------------------
resource "aws_cloudwatch_log_group" "matchmaking" {
  name              = "/ecs/${local.prefix}-matchmaking-service"
  retention_in_days = 30

  tags = {
    Name = "${local.prefix}-matchmaking-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "matchmaking" {
  name           = "${local.prefix}-matchmaking-logs"
  log_group_name = aws_cloudwatch_log_group.matchmaking.name
}
