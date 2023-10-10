data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases          = [var.ckan_url]
  comment          = "CKAN"
  enabled          = true
  http_version     = "http2"
  is_ipv6_enabled  = false
  price_class      = "PriceClass_100"
  retain_on_delete = false
  tags = {
    "Name" = "ckan-cloudfront"
  }
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "*",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  logging_config {
    bucket          = aws_s3_bucket.cloudfront_logs.bucket_domain_name
    include_cookies = true
    prefix          = "cloudfront/"
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/dataset/*/resource/*/download/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/dataset/*/resource/*/view/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/*/dataset/*/resource/*/view/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/webassets/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/uploads/admin/*.png"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/base/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/api/i18n/*"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress                 = false
    default_ttl              = 0
    max_ttl                  = 0
    min_ttl                  = 0
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id
    path_pattern             = "/api/3/action/*"
    smooth_streaming         = false
    target_origin_id         = "ckan"
    trusted_key_groups       = []
    trusted_signers          = []
    viewer_protocol_policy   = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 604800
    max_ttl                = 604800
    min_ttl                = 604800
    path_pattern           = "/about"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 3600
    max_ttl                = 3600
    min_ttl                = 3600
    path_pattern           = "/dataset/"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 3600
    max_ttl                = 3600
    min_ttl                = 3600
    path_pattern           = "/dataset"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 3600
    max_ttl                = 3600
    min_ttl                = 3600
    path_pattern           = "/*/dataset/"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 3600
    max_ttl                = 3600
    min_ttl                = 3600
    path_pattern           = "/*/dataset"
    smooth_streaming       = false
    target_origin_id       = "ckan"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "auth_tkt",
        ]
      }
    }
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_alb.application-load-balancer.dns_name
    origin_id           = "ckan"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 60
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.ckan_certificate.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }
}

resource "aws_route53_record" "route-to-cloudfront" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.ckan_url
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "ckan_cloudfront_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.ckan_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}

resource "aws_acm_certificate" "ckan_certificate" {
  provider          = aws.us_east
  domain_name       = var.ckan_url
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider                = aws.us_east
  certificate_arn         = aws_acm_certificate.ckan_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.ckan_cloudfront_validation_record : record.fqdn]
}


resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "${var.ckan_url}-cloudfront-logs"

  lifecycle {
    ignore_changes = [
      grant, # Managed by CloudFront; ignore the changes
    ]
  }
}