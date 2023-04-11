output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "load_balancer_dns" {
  value = aws_alb.application-load-balancer.dns_name
}

output "load_balancer_arn" {
  value = aws_alb.application-load-balancer.arn
}
