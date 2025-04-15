resource "aws_security_group" "solr" {
  name        = "${var.resource_name_prefix}-solr"
  vpc_id      = var.vpc_id
  description = "Allow Ingress to Solr Container"

  egress {
    description      = "allow all egress from solr container"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "ckan-to-solr" {
  description              = "ckan-to-solr"
  from_port                = 8983
  protocol                 = "-1"
  security_group_id        = aws_security_group.solr.id
  to_port                  = 8983
  type                     = "ingress"
  source_security_group_id = aws_security_group.ckan.id
}

resource "aws_security_group_rule" "elb-to-solr" {
  description              = "elb-to-solr"
  from_port                = 8983
  protocol                 = "-1"
  security_group_id        = aws_security_group.solr.id
  to_port                  = 8983
  type                     = "ingress"
  source_security_group_id = aws_security_group.elb.id
}


resource "aws_ecs_service" "solr" {
  name                = "solr"
  task_definition     = aws_ecs_task_definition.solr.id
  cluster             = module.ecs.cluster_name
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = "1.4.0"
  #health_check_grace_period_seconds = 120
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_alb_target_group.solr-http.id
    container_name   = "solr"
    container_port   = "8983"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.solr.arn
  }


  network_configuration {
    #assign_public_ip = true
    subnets = var.private_subnet_ids_list
    security_groups = [
      aws_security_group.solr.id,
    ]
  }

  depends_on = [
    aws_alb_listener.solr-http
  ]


}

resource "aws_ecs_task_definition" "solr" {
  family                   = "solr"
  cpu                      = 2048
  memory                   = 4096
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name      = "solr"
      image     = "nathstevo97/ckan-solr:latest"
      essential = true
      memory    = 4096
      cpu       = 2048
      portMappings = [
        {
          hostPort      = 8983
          protocol      = "tcp"
          containerPort = 8983
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.solr.name}"
          awslogs-region        = "${var.aws_region}"
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = [
        {
          containerPath = "/opt/solr/server/solr/ckan/data"
          sourceVolume  = "efs-solr"
        }
      ]
    }
  ])

  volume {
    name = "efs-solr"
    efs_volume_configuration {
      file_system_id = module.efs-solr.efs_id
      root_directory = "/"
    }
  }

  network_mode = "awsvpc"

  depends_on = [aws_cloudwatch_log_group.solr]

}