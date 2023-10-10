data "aws_ec2_managed_prefix_list" "cloudwatch" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "elb" {
  name = "${var.resource_name_prefix}-elb-sg"

  vpc_id = var.vpc_id

  ingress {
    #cidr_blocks = var.allowed_cidr_blocks
    cidr_blocks = ["0.0.0.0/0"]
    #prefix_list_ids = [ data.aws_ec2_managed_prefix_list.cloudwatch.id ]
    description = "http to ELB"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    #cidr_blocks = var.allowed_cidr_blocks
    #cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudwatch.id]
    description     = "https to ELB"
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_alb" "application-load-balancer" {
  name = "${var.resource_name_prefix}-elb"
  security_groups = [
    aws_security_group.elb.id
  ]
  idle_timeout               = 60
  subnets                    = var.public_subnet_ids_list
  drop_invalid_header_fields = true
}


//--------- Datapusher

resource "aws_alb_listener" "datapusher-http" {
  load_balancer_arn = aws_alb.application-load-balancer.id
  port              = "8800"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.datapusher-http.id
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.datapusher-http]
}

resource "aws_alb_target_group" "datapusher-http" {
  name                 = "datapusher"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  port                 = 8800
  deregistration_delay = 10

  health_check {
    path = "/"
  }
}


//------------ Solr

resource "aws_alb_listener" "solr-http" {
  load_balancer_arn = aws_alb.application-load-balancer.id
  port              = "8983"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.solr-http.id
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.solr-http]
}

resource "aws_alb_target_group" "solr-http" {
  name                 = "solr"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  port                 = 8983
  deregistration_delay = 10
}

//------------ CKAN

resource "aws_alb_listener" "ckan-http" {
  load_balancer_arn = aws_alb.application-load-balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_alb_target_group.ckan-http
  ]
}

resource "aws_alb_target_group" "ckan-http" {
  name                 = "ckan"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  port                 = 5000
  deregistration_delay = 10

  health_check {
    path = "/api/3/action/status_show"
  }
}

resource "aws_alb_listener" "ckan-https" {
  load_balancer_arn = aws_alb.application-load-balancer.id
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = var.lb_acm_certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ckan-http.arn
  }

  depends_on = [aws_alb_target_group.ckan-http]
}