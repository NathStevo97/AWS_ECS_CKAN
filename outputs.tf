output "database_address" {
  value     = module.postgres.db_instance_address
  sensitive = true
}

output "redis_address" {
  value = module.redis.redis-address
}

# output "cloudfront_distribution" {
#   value = module.ckan-cluster.cloudfront_distribution
# }

# output "load_balancer_dns" {
#   value = module.ckan-cluster.load_balancer_dns
# }

# output "load_balancer_arn" {
#   value = module.ckan-cluster.load_balancer_arn
# }