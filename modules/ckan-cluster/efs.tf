module "efs-ckan" {
  source                     = "../efs"
  name                       = "${var.resource_name_prefix}-ckan"
  mount_target_subnet_ids    = var.private_subnet_ids_list
  vpc_id                     = var.vpc_id
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = aws_security_group.ckan.id
}

module "efs-solr" {
  source                     = "../efs"
  name                       = "${var.resource_name_prefix}-solr"
  mount_target_subnet_ids    = var.private_subnet_ids_list
  vpc_id                     = var.vpc_id
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = aws_security_group.solr.id
}