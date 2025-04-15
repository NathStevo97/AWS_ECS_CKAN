variable "resource_name_prefix" {
  type        = string
  description = "resource name prefix e.g. ckan-poc-"
}
variable "private_subnet_ids_list" {
  type        = list(string)
  description = "Private Subnet IDs for resource allocation"
}
variable "hosted_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID for CKAN Domains."
}
variable "domain_name" {
  type        = string
  description = "Domain name for Redis e.g. redis.<domain>"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID for resources to be assigned to"
}
variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Network CIDR blocks the database will accept communications from, typically this just needs to be the VPC Cidr."
}