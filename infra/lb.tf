locals {
  matchmaking_port = 8081
}
# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${local.prefix}-lb-sg"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

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
  vpc_id      = aws_vpc.main.id

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
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "matchmaking" {
  name        = "${local.prefix}-matchmaking-target-group"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
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
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_alb_target_group.matchmaking.id
    type             = "forward"
  }
}