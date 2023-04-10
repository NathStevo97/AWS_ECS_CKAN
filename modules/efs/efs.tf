resource "aws_efs_file_system" "efs" {
  encrypted = true
  tags = {
    Name            = var.name,
    BackupWeekly    = "true",
    BackupQuarterly = "true"
  }
}

resource "aws_efs_mount_target" "efs-a" {
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = var.mount_target_subnet_ids[0]
}

resource "aws_efs_mount_target" "efs-b" {
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = var.mount_target_subnet_ids[1]
}

resource "aws_efs_mount_target" "efs-c" {
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = var.mount_target_subnet_ids[2]
}

resource "aws_security_group" "efs" {
  name   = "${var.name}-efs"
  vpc_id = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "cidr-efs" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "group" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids
  security_group_id        = aws_security_group.efs.id
}