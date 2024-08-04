locals {
  matchmaking_port = 8081
  app_image        = "alexslaterio/${local.prefix}-matchmaking-service"
  fargate_memory   = 512
  fargate_cpu      = 256
}

# --------------------------------------------------------------
# --- ECR / IMAGE ---
# --------------------------------------------------------------
module "matchmaking_ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_force_delete = true
  repository_name         = local.app_image
  repository_lifecycle_policy = jsonencode({
    rules = [{
      action       = { type = "expire" }
      description  = "Delete all images except a handful of the newest images"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
}
resource "docker_image" "matchmaking" {
  name = format("%v:%v", module.matchmaking_ecr.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))

  build { context = "../core/src/docker/matchmaking" }
  # triggers = {
  #   dir_sha1 = sha1(join("", [for f in fileset(path.module, "src/*") : filesha1(f)]))
  # }
}
resource "docker_registry_image" "matchmaking" {
  keep_remotely = true # Do not delete old images when a new image is pushed
  name          = resource.docker_image.matchmaking.name
}

# --- Load Balancer ---
resource "aws_security_group" "lb" {
  name        = "${local.prefix}-lb-sg"
  description = "controls access to the ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = local.matchmaking_port
    to_port     = local.matchmaking_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.prefix}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = local.matchmaking_port
    to_port         = local.matchmaking_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_alb" "main" {
  name            = "${local.prefix}-lb"
  subnets         = data.aws_subnets.public.ids
  security_groups = [aws_security_group.lb.id]
}
resource "aws_alb_target_group" "matchmaking" {
  name        = "${local.prefix}-matchmaking-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }
}
# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "matchmaking" {
  load_balancer_arn = aws_alb.main.id
  port              = local.matchmaking_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.matchmaking.id
    type             = "forward"
  }
}
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
    app_image        = local.app_image
    matchmaking_port = local.matchmaking_port
    fargate_cpu      = local.fargate_cpu
    fargate_memory   = local.fargate_memory
    aws_region       = var.aws_region
  }
}
resource "aws_ecs_task_definition" "matchmaking" {
  family                   = "${local.prefix}-matchmaking-task"
  execution_role_arn       = aws_iam_role.matchmaking_task.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.fargate_cpu
  memory                   = local.fargate_memory
  container_definitions    = data.template_file.matchmaking.rendered
  depends_on               = [docker_registry_image.matchmaking]
}
resource "aws_iam_role" "matchmaking_task" {
  name               = "${local.prefix}-matchmaking-task"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
resource "aws_ecs_service" "matchmaking" {
  name            = "${local.prefix}-matchmaking-service"
  cluster         = aws_ecs_cluster.matchmaking.id
  task_definition = aws_ecs_task_definition.matchmaking.arn
  desired_count   = 1
  launch_type     = "FARGATE"

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

  depends_on = [aws_alb_listener.matchmaking]
}

