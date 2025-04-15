variable "resource_name_prefix" {
  type        = string
  description = "resource name prefix e.g. ckan-poc-"
}

variable "instance_class" {
  type        = string
  description = "Database instance type e.g. db.t2.micro, this can be adjusted to suit using the options at https://aws.amazon.com/rds/instance-types/"
}

variable "rds_database_name" {
  type        = string
  description = "Name of RDS Database to be created"
}
variable "rds_database_password" {
  type        = string
  sensitive   = true
  description = "Base password for Postgres RDS"
}
variable "rds_database_username" {
  type        = string
  description = "Base username for Postgres RDS"
}
variable "domain_name" {
  type        = string
  description = "Domain name for Database e.g. postgres.<domain name>"
}
variable "hosted_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID for CKAN Domains."
}
variable "vpc_id" {
  type        = string
  description = "VPC ID for resources to be assigned to"
}
variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Network CIDR blocks the database will accept communications from, typically this just needs to be the VPC Cidr."
}
variable "private_subnet_ids_list" {
  type        = list(string)
  description = "Private Subnet IDs for resource allocation"
}