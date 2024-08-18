terraform {
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.63.0"
    }
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "= 6.8.0"

  # storage
  allocated_storage = 20
  storage_encrypted = false
  storage_type      = "gp2"

  # maintenance and backup
  backup_retention_period          = 35
  backup_window                    = "03:30-04:30"
  copy_tags_to_snapshot            = true
  final_snapshot_identifier_prefix = "${var.resource_name_prefix}-final"
  skip_final_snapshot              = true

  identifier = var.resource_name_prefix

  # instance
  deletion_protection = false
  # create_db_subnet_group is now set to false by default in the new module version
  # which tries to destroy the current subnet group.
  create_db_subnet_group = true
  engine                 = "postgres"
  engine_version         = "16.3"
  family                 = "postgres16"
  instance_class         = var.instance_class
  major_engine_version   = 11
  multi_az               = true
  db_name                = var.rds_database_name
  port                   = 5432

  # credentials
  password = var.rds_database_password
  username = var.rds_database_username
  # update module has create_random_password set to true, which we do not want.
  # create_random_password = false

  # networking
  subnet_ids             = var.private_subnet_ids_list
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true

  # tags
  # new module version has added a new db_instance_tag attribute
  db_instance_tags = { "Name" = "${var.resource_name_prefix}-db" }
}

# dns
resource "aws_route53_record" "postgres" {
  zone_id = var.hosted_zone_id
  name    = var.postgres_url
  type    = "CNAME"
  ttl     = "300"
  records = [module.rds.db_instance_address]
}

# security group
resource "aws_security_group" "rds" {
  name   = "${var.resource_name_prefix}-db-sg"
  vpc_id = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${var.resource_name_prefix}-db-sg" }
}

# rules
resource "aws_security_group_rule" "postgres-cidr" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = var.allowed_cidr_blocks
}