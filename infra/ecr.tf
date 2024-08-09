# --------------------------------------------------------------
# --- ECR / IMAGE ---
# --------------------------------------------------------------
locals {
  docker_image_tag = sha1(join("", concat([for f in fileset("${path.root}/../core/src/matchmaking", "src/*") : filesha1("${path.root}/../core/src/matchmaking/${f}")], [filesha1("${path.root}/../core/src/matchmaking/Dockerfile")])))
}
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
  name = format("%v:%v", module.matchmaking_ecr.repository_url, local.docker_image_tag)

  build { context = "../core/src/matchmaking" }
  platform = "linux/amd64"

  triggers = {
    dir_sha1 = local.docker_image_tag
  }
}
resource "docker_registry_image" "matchmaking" {
  keep_remotely = true # Do not delete old images when a new image is pushed
  name          = resource.docker_image.matchmaking.name
}

# --------------------------------------------------------------
# --- AUTO SCALING ---
# --------------------------------------------------------------
# resource "aws_appautoscaling_target" "target" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.matchmaking.name}/${aws_ecs_service.matchmaking.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   role_arn           = aws_iam_role.ecs_auto_scale_role.arn
#   min_capacity       = 0
#   max_capacity       = 1
# }

# # Automatically scale capacity up by one
# resource "aws_appautoscaling_policy" "up" {
#   name               = "cb_scale_up"
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
#   scalable_dimension = "ecs:service:DesiredCount"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }
#   }

#   depends_on = [aws_appautoscaling_target.target]
# }

# # Automatically scale capacity down by one
# resource "aws_appautoscaling_policy" "down" {
#   name               = "cb_scale_down"
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
#   scalable_dimension = "ecs:service:DesiredCount"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = -1
#     }
#   }

#   depends_on = [aws_appautoscaling_target.target]
# }

# # CloudWatch alarm that triggers the autoscaling up policy
# resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
#   alarm_name          = "cb_cpu_utilization_high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "85"

#   dimensions = {
#     ClusterName = aws_ecs_cluster.main.name
#     ServiceName = aws_ecs_service.main.name
#   }

#   alarm_actions = [aws_appautoscaling_policy.up.arn]
# }

# # CloudWatch alarm that triggers the autoscaling down policy
# resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
#   alarm_name          = "cb_cpu_utilization_low"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "10"

#   dimensions = {
#     ClusterName = aws_ecs_cluster.main.name
#     ServiceName = aws_ecs_service.main.name
#   }

#   alarm_actions = [aws_appautoscaling_policy.down.arn]
# }
