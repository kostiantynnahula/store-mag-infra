resource "aws_route53_zone" "store_mag" {
  name = var.domain_name
}

resource "aws_acm_certificate" "store_mag_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "store_mag_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.store_mag_cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = aws_route53_zone.store_mag.zone_id

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 300

  depends_on = [aws_acm_certificate.store_mag_cert]
}

resource "aws_route53_record" "store_mag" {
  zone_id = aws_route53_zone.store_mag.zone_id
  name    = var.domain_name

  type = "A"
  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "store_mag_cert_validation" {
  certificate_arn = aws_acm_certificate.store_mag_cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.store_mag_cert_validation :
    record.fqdn
  ]
}
