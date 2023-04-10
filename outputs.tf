output "database_address" {
 value = module.postgres.db_instance_address
 sensitive = true
}

output "redis_address" {
 value = module.redis.redis-address
}