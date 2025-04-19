resource "aws_security_group" "datapusher" {
  name        = "${var.resource_name_prefix}-datapusher"
  vpc_id      = var.vpc_id
  description = "Allow Ingress to CKAN-Datapusher Container"

  egress {
    description      = "allow all egress from ckan-datapusher container"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "ckan-to-datapusher" {
  description              = "ckan-to-datapusher"
  from_port                = 8800
  protocol                 = "-1"
  security_group_id        = aws_security_group.datapusher.id
  to_port                  = 8800
  type                     = "ingress"
  source_security_group_id = aws_security_group.ckan.id
}


resource "aws_security_group_rule" "elb-to-datapusher" {
  description              = "elb-to-datapusher"
  from_port                = 8800
  protocol                 = "-1"
  security_group_id        = aws_security_group.datapusher.id
  to_port                  = 8800
  type                     = "ingress"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_ecs_service" "datapusher" {
  name                = "datapusher"
  task_definition     = aws_ecs_task_definition.datapusher.id
  cluster             = module.ecs.cluster_name
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = "1.4.0"

  load_balancer {
    target_group_arn = aws_alb_target_group.datapusher-http.id
    container_name   = "datapusher"
    container_port   = "8800"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.datapusher.arn
  }

  network_configuration {
    subnets = var.private_subnet_ids_list
    security_groups = [
      aws_security_group.datapusher.id
    ]
  }

  depends_on = [
    module.ecs
  ]
}

resource "aws_ecs_task_definition" "datapusher" {
  family                   = "datapusher"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name              = "datapusher"
      image             = "nathstevo97/ckan-datapusher"
      cpu               = 1024
      memory            = 2048
      memoryReservation = 128
      essential         = true
      portMappings = [
        {
          containerPort = 8800
          hostPort      = 8800
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.datapusher.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  network_mode = "awsvpc"

  depends_on = [
    aws_cloudwatch_log_group.datapusher,
    module.ecs
  ]

}