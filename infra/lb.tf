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
resource "aws_alb_listener" "matchmaking_http" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_alb_listener" "matchmaking_https" {
  load_balancer_arn = aws_alb.main.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.matchmaking.id
    type             = "forward"
  }
}
resource "aws_security_group" "lb" {
  name        = "${local.prefix}-lb-sg"
  description = "controls access to the ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
#  cloudflare record
resource "cloudflare_record" "matchmakingalexslaterio" {
  zone_id         = data.cloudflare_zone.alexslaterio.id
  name            = local.matchmaking_subdomain
  type            = "CNAME"
  value           = aws_alb.main.dns_name
  ttl             = 1
  proxied         = true
  allow_overwrite = true
}
