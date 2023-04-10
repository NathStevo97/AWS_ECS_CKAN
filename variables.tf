variable "resource_name_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "availability_zone_map" {
  type = map(any)
}

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
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

variable "instance_class" {
  type        = string
  description = "Database instance type e.g. db.t2.micro, this can be adjusted to suit using the options at https://aws.amazon.com/rds/instance-types/"
}



variable "admin_cidr_blocks" {
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
/*
variable "ckan_admin" {
  type = string
}

variable "ckan_admin_password" {
  type = string
}
*/


variable "acm_certificate_arn" {
  type = string
}
