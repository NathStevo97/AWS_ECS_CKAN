data "aws_route53_zone" "zone" {
  zone_id      = var.hosted_zone_id
  private_zone = false
}