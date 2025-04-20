output "db_instance_address" {
  value     = module.rds.db_instance_address
  sensitive = true
}

output "db_instance_name" {
  value = module.rds.db_instance_name
}