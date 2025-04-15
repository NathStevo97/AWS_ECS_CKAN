terraform {
  required_version = ">= 1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.91.0"
    }
  }
}

resource "aws_elasticache_subnet_group" "group" {
  name       = "${var.resource_name_prefix}-redis"
  subnet_ids = var.private_subnet_ids_list
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.resource_name_prefix}-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  apply_immediately    = true
  subnet_group_name    = aws_elasticache_subnet_group.group.name
  security_group_ids   = [aws_security_group.redis.id]
}

# dns
resource "aws_route53_record" "redis" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "redis.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_cluster.redis.cache_nodes[0].address]
}

# security group
resource "aws_security_group" "redis" {
  name        = "${var.resource_name_prefix}-redis"
  vpc_id      = var.vpc_id
  description = "Allow all Redis Egress, and Ingress within allowed CIDR range"

  egress {
    description      = "allow all egress from elasticache"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# rules
resource "aws_security_group_rule" "redis-cidr" {
  description       = "allow ingress from ckan cluster cidrs"
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.redis.id
  cidr_blocks       = var.allowed_cidr_blocks
}