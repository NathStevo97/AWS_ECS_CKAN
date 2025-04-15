variable "resource_name_prefix" {
  type    = string
  default = "ckan"
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "availability_zone_map" {
  type = map(any)
  default = {
    "eu-west-2a" = "eu-west-2a"
    "eu-west-2b" = "eu-west-2b"
    "eu-west-2c" = "eu-west-2c"
  }
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "hosted_zone_id" {
  type    = string
  default = ""
}

variable "rds_database_name" {
  type    = string
  default = "ckan"
}

variable "rds_database_username" {
  type    = string
  default = "ckan"
}

variable "rds_database_password" {
  type    = string
  default = "ckan"
}

variable "instance_class" {
  type        = string
  description = "Database instance type e.g. db.t2.micro, this can be adjusted to suit using the options at https://aws.amazon.com/rds/instance-types/"
  default     = "db.t2.micro"
}



variable "admin_cidr_blocks" {
  type    = string
  default = ""
}

variable "rds_readonly_database_name" {
  type    = string
  default = "ckan_readonly"
}

variable "rds_readonly_database_user" {
  type    = string
  default = "readonly"
}

variable "rds_readonly_database_password" {
  type    = string
  default = "readonly"
}
/*
variable "ckan_admin" {
  type = string
}

variable "ckan_admin_password" {
  type = string
}
*/


variable "lb_acm_certificate_arn" {
  type    = string
  default = ""
}
