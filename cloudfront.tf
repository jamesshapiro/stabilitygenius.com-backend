locals {
  s3_origin_id = "StabilityGeniusOrigin"
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "Stability Genius OAI"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }
  enabled             = true
  comment             = "Stability Genius"
  default_root_object = "index.html"

  aliases = [
    var.domain_name, "www.${var.domain_name}"
  ]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.validate.certificate_arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}