variable "resource_name_prefix" {
  type = string
  description = "resource name prefix e.g. ckan-poc-"
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
  description = "VPC ID for resources to be assigned to"
}

variable "private_subnet_ids_list" {
  type = list(string)
  description = "Private Subnet IDs for resource allocation"
}

variable "public_subnet_ids_list" {
  type = list(string)
  description = "Public Subnet IDs for resource allocation."
}


variable "allowed_cidr_blocks" {
  type = list(string)
  description = "VPC Cidr containers and resources are to be allocated to and communicate over"
}

variable "hosted_zone_id" {
  type = string
  description = "Route53 Hosted Zone ID for CKAN Domains."
}

variable "redis_url" {
  type = string
  description = "Redis FQDN e.g. redis.<domain name>"
}

variable "postgres_url" {
  type = string
  description = "Postgres FQDN e.g. db.<domain name>"
}

variable "ckan_url" {
  type = string
  description = "CKAN FQDN e.g. ckan.<domain name>"
}

variable "rds_database_name" {
  type = string
}

variable "rds_database_username" {
  type = string
}

variable "rds_database_password" {
  type = string
}

variable "rds_readonly_database_name" {
  type = string
}

variable "rds_readonly_database_user" {
  type = string
}

variable "rds_readonly_database_password" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}