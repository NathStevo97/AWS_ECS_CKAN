variable "name" {
  type        = string
  description = "The EFS name."
}
variable "mount_target_subnet_ids" {
  type        = list(string)
  description = "A list of `subnet_id` where the EFS will be mounted."
}
variable "vpc_id" {
  type        = string
  description = "The `vpc_id` where the EFS will be provisioned."
}
variable "allowed_security_group_ids" {
  type        = string
  description = "A list of `security_group_id` will be used to make EFS connections."
  default     = ""
}
variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "A list of cidr_blocks that will be allowed to mount"
  default     = []
}