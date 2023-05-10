
data "aws_route53_zone" "domain_zone" {
  name         = var.root_domain_name
  private_zone = false
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
}

resource "aws_route53_record" "a_record" {
  allow_overwrite = true
  name            = var.domain_name
  type            = "A"
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    # Note: This HostedZoneID is always used for every CF distribution so it can be hard-coded in
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cname_record" {
  allow_overwrite = true
  name            = "www.${var.domain_name}"
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
  records         = [var.domain_name]
  ttl             = 60
}
