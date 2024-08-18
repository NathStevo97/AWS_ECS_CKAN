
# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "${var.resource_name_prefix}-vpc"

  cidr = var.vpc_cidr

  azs = formatlist("%s%s", var.region, keys(var.availability_zone_map))

  private_subnets = [for n in toset(values(var.availability_zone_map)) : cidrsubnet(var.vpc_cidr, 8, tonumber(n) + 128)]

  private_dedicated_network_acl = true
  private_inbound_acl_rules = [
    merge(local.acls.http, { rule_number = 100, cidr_block = var.vpc_cidr }),
    merge(local.acls.https, { rule_number = 101, cidr_block = var.vpc_cidr }),
    merge(local.acls.ntp, { rule_number = 102 }),
    merge(local.acls.ephemeral, { rule_number = 103 }),
  ]
  private_outbound_acl_rules = [
    merge(local.acls.all, { rule_number = 100, cidr_block = var.vpc_cidr }),
    merge(local.acls.http, { rule_number = 101 }),
    merge(local.acls.https, { rule_number = 102 }),
    merge(local.acls.smtp, { rule_number = 103 }),
    merge(local.acls.ephemeral, { rule_number = 104 }),
  ]


  public_subnets = [for n in toset(values(var.availability_zone_map)) : cidrsubnet(var.vpc_cidr, 8, tonumber(n))]

  public_dedicated_network_acl = true
  public_inbound_acl_rules = [
    merge(local.acls.http, { rule_number = 100 }),
    merge(local.acls.https, { rule_number = 101 }),
    merge(local.acls.ntp, { rule_number = 102 }),
    merge(local.acls.smtp, { rule_number = 103 }),
    merge(local.acls.ephemeral, { rule_number = 104 }),
    merge(local.acls.ephemeral, { rule_number = 105, protocol = "udp" })
  ]
  public_outbound_acl_rules = [
    merge(local.acls.all, { rule_number = 100, cidr_block = var.vpc_cidr }),
    merge(local.acls.http, { rule_number = 101 }),
    merge(local.acls.https, { rule_number = 102 }),
    merge(local.acls.ntp, { rule_number = 103 }),
    merge(local.acls.smtp, { rule_number = 104 }),
    merge(local.acls.ephemeral, { rule_number = 105 }),
  ]


  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Postgres RDS Module

module "postgres" {
  source                  = "./modules/postgres"
  resource_name_prefix    = var.resource_name_prefix
  postgres_url            = "postgres.${var.domain_name}"
  hosted_zone_id          = var.hosted_zone_id
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids_list = module.vpc.private_subnets
  rds_database_name       = var.rds_database_name
  rds_database_password   = var.rds_database_password
  rds_database_username   = var.rds_database_username
  allowed_cidr_blocks     = [var.vpc_cidr, var.admin_cidr_blocks]
  instance_class          = var.instance_class
}

# Redis Elasticache Module

module "redis" {
  source                  = "./modules/redis"
  resource_name_prefix    = var.resource_name_prefix
  redis_url               = "redis.${var.domain_name}"
  hosted_zone_id          = var.hosted_zone_id
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids_list = module.vpc.private_subnets
  allowed_cidr_blocks     = [var.vpc_cidr, var.admin_cidr_blocks]
}

# CKAN Cluster

module "ckan-cluster" {
  source                         = "./modules/ckan-cluster"
  resource_name_prefix           = var.resource_name_prefix
  hosted_zone_id                 = var.hosted_zone_id
  vpc_id                         = module.vpc.vpc_id
  public_subnet_ids_list         = module.vpc.public_subnets
  private_subnet_ids_list        = module.vpc.private_subnets
  allowed_cidr_blocks            = [var.vpc_cidr, var.admin_cidr_blocks]
  postgres_url                   = "postgres.${var.domain_name}"
  redis_url                      = "redis.${var.domain_name}"
  ckan_url                       = "ckan.${var.domain_name}"
  aws_region                     = var.region
  rds_database_name              = var.rds_database_name
  rds_database_password          = var.rds_database_password
  rds_database_username          = var.rds_database_username
  rds_readonly_database_name     = var.rds_readonly_database_name
  rds_readonly_database_password = var.rds_readonly_database_password
  rds_readonly_database_user     = var.rds_readonly_database_user
  lb_acm_certificate_arn         = var.lb_acm_certificate_arn
}