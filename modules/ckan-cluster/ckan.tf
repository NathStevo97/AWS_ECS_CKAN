resource "aws_security_group" "ckan" {
  name        = "${var.resource_name_prefix}-ckan"
  description = "Allow ingress to CKAN container"
  vpc_id      = var.vpc_id

  egress {
    description      = "allow all egress from ckan container"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "datapusher-to-ckan" {
  description              = "datapusher-to-ckan"
  from_port                = 8800
  protocol                 = "-1"
  security_group_id        = aws_security_group.ckan.id
  to_port                  = 8800
  type                     = "ingress"
  source_security_group_id = aws_security_group.datapusher.id
}

resource "aws_security_group_rule" "elb-to-ckan" {
  description              = "elb-to-ckan"
  from_port                = 5000
  protocol                 = "-1"
  security_group_id        = aws_security_group.ckan.id
  to_port                  = 5000
  type                     = "ingress"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_ecs_service" "ckan" {
  name                   = "ckan"
  task_definition        = aws_ecs_task_definition.ckan.id
  cluster                = module.ecs.cluster_name
  desired_count          = 1
  launch_type            = "FARGATE"
  scheduling_strategy    = "REPLICA"
  platform_version       = "1.4.0"
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_alb_target_group.ckan-http.id
    container_name   = "ckan"
    container_port   = "5000"
  }


  #health_check_grace_period_seconds = 600

  network_configuration {
    assign_public_ip = true
    subnets          = concat(var.public_subnet_ids_list, var.private_subnet_ids_list)
    security_groups = [
      aws_security_group.ckan.id
    ]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ckan.arn
  }

  depends_on = [
    aws_alb_listener.ckan-http,
    #aws_alb_listener.ckan-https,
    aws_alb_listener.solr-http,
    module.ecs
  ]
}

resource "aws_ecs_task_definition" "ckan" {
  family                = "ckan"
  cpu                   = 2048
  memory                = 4096
  execution_role_arn    = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn         = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    name = "ckan"
    image = "nathstevo97/ckan:latest"
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      secretOptions = null
      options = {
        "awslogs-group"         = "${aws_cloudwatch_log_group.ckan.name}",
        "awslogs-region"       = "${var.aws_region}",
        "awslogs-stream-prefix" = "ecs"
      }
    }
    portMappings = [
      {
        hostPort = 5000,
        protocol = "tcp",
        containerPort = 5000
      }
    ]
    cpu = 2048,
    memoryReservation = 512,
    mountPoints = [
      {
        containerPath = "/var/lib/ckan",
        sourceVolume  = "efs-ckan-storage"
      }
    ]
    memory = 4096
    environment = [
      {
        name = "CKAN_SITE_URL",
        value = "https://${var.ckan_url}"
      },
      {
        name = "SESSION_SECRET"
        value = "string:CHANGE_ME"
      },
      {
        name = "CKAN_API_TOKEN_SECRET"
        value = "string:CHANGE_ME"
      },
      {
        name = "POSTGRES_DB",
        value = "${var.rds_database_name}"
      },
      {
        name = "POSTGRES_USER",
        value = "${var.rds_database_username}"
      },
      {
        name = "POSTGRES_PASSWORD",
        value = "${var.rds_database_password}"
      },
      {
        name = "POSTGRES_FQDN",
        value = "${var.postgres_url}"
      },
      {
        name = "DATASTORE_DB",
        value = "${var.rds_readonly_database_name}"
      },
      {
        name = "DATASTORE_ROLENAME",
        value = "${var.rds_readonly_database_user}"
      },
      {
        name = "DATASTORE_PASSWORD",
        value = "${var.rds_readonly_database_password}"
      },
      {
        name = "REDIS_FQDN",
        value = "${var.redis_url}"
      },
      {
        name = "SOLR_CORE_NAME",
        value = "ckan"
      },
      {
        name = "SOLR_FQDN",
        value = "${aws_service_discovery_service.solr.name}.${aws_service_discovery_private_dns_namespace.ckan-infrastructure.name}"
      },
      {
        name = "DATAPUSHER_FQDN",
        value = "${aws_service_discovery_service.datapusher.name}.${aws_service_discovery_private_dns_namespace.ckan-infrastructure.name}"
      }
    ]
  ])

  volume {
    name = "efs-ckan-storage"

    efs_volume_configuration {
      file_system_id = module.efs-ckan.efs_id
      root_directory = "/"
    }
  }

  network_mode = "awsvpc"

  depends_on = [aws_cloudwatch_log_group.ckan, module.ecs]
}