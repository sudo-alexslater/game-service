[
  {
    "essential": true,
    "name": "${app_name}",
    "image": "${app_image}",
    "memory": ${fargate_memory},
    "cpu": ${fargate_cpu},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group_name}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${matchmaking_port},
        "hostPort": ${matchmaking_port}
      }
    ]
  }
]