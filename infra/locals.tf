locals {
  matchmaking_port = 8081
  app_image        = "alexslaterio/${local.prefix}-matchmaking-service"
  fargate_memory   = 512
  fargate_cpu      = 256
}
