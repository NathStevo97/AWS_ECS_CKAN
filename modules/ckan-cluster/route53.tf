data "aws_route53_zone" "zone" {
  zone_id      = var.hosted_zone_id
  private_zone = false
}

resource "aws_route53_record" "main" {
  #zone_id = data.aws_route53_zone.zone.zone_id
  zone_id = "/hostedzone/${var.hosted_zone_id}"
  name    = var.ckan_url
  type    = "A"

  alias {
    evaluate_target_health = true
    name = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
    #name                   = aws_alb.application-load-balancer.dns_name
    #zone_id                = aws_alb.application-load-balancer.zone_id
  }
}