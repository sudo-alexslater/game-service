# --------------------------------------------------------------
# --- ECS CLUSTER ---
# --------------------------------------------------------------
resource "aws_ecs_cluster" "matchmaking" {
  name = "${local.prefix}-matchmaking-cluster"
}
data "template_file" "matchmaking" {
  template = file("./templates/ecs/matchmaking.json.tpl")

  vars = {
    app_name         = "${local.prefix}-matchmaking-service"
    app_image        = "${module.matchmaking_ecr.repository_url}:${local.docker_image_tag}"
    matchmaking_port = local.matchmaking_port
    log_group_name   = aws_cloudwatch_log_group.matchmaking.name
    fargate_cpu      = local.fargate_cpu
    fargate_memory   = local.fargate_memory
    aws_region       = var.aws_region
  }
}
resource "aws_ecs_task_definition" "matchmaking" {
  family             = "${local.prefix}-matchmaking-task"
  execution_role_arn = aws_iam_role.matchmaking_task.arn
  network_mode       = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.fargate_cpu
  memory                   = local.fargate_memory
  container_definitions    = data.template_file.matchmaking.rendered
  depends_on               = [docker_registry_image.matchmaking]
}
resource "aws_ecs_service" "matchmaking" {
  name                              = "${local.prefix}-matchmaking-service"
  cluster                           = aws_ecs_cluster.matchmaking.id
  task_definition                   = aws_ecs_task_definition.matchmaking.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.matchmaking.id
    container_name   = "${local.prefix}-matchmaking-service"
    container_port   = local.matchmaking_port
  }

  depends_on = [aws_alb_listener.matchmaking_http, aws_alb_listener.matchmaking_https]
}
resource "aws_iam_role" "matchmaking_task" {
  name               = "${local.prefix}-matchmaking-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role = aws_iam_role.matchmaking_task.name

  // This policy adds logging + ecr permissions
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.prefix}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
