# ecs.tf

resource "aws_ecs_cluster" "matchmaking" {
  name = "${local.prefix}-matchmaking-cluster"
}

data "template_file" "matchmaking" {
  template = file("./templates/ecs/matchmaking.json.tpl")

  vars = {
    app_name         = "${local.prefix}-matchmaking"
    app_image        = var.app_image
    matchmaking_port = local.matchmaking_port
    # fargate_cpu      = var.fargate_cpu
    # fargate_memory   = var.fargate_memory
    aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "matchmaking" {
  family                   = "${local.prefix}-matchmaking-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # cpu                      = var.fargate_cpu
  # memory                   = var.fargate_memory
  container_definitions = data.template_file.matchmaking
}

resource "aws_ecs_service" "matchmaking" {
  name            = "${local.prefix}-matchmaking-service"
  cluster         = aws_ecs_cluster.matchmaking.id
  task_definition = aws_ecs_task_definition.matchmaking.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # network_configuration {
  #     security_groups  = [aws_security_group.ecs_tasks.id]
  #     subnets          = aws_subnet.private.*.id
  #     assign_public_ip = true
  # }

  load_balancer {
    target_group_arn = aws_alb_target_group.matchmaking.id
    container_name   = "${local.prefix}-matchmaking-service"
    container_port   = local.matchmaking_port
  }

  depends_on = [aws_alb_listener.matchmaking, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}
