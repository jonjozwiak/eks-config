provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

resource "aws_route53_zone" "main-domain" {
  name = var.domain
}

resource "aws_route53_zone" "main-subdomain" {
  name = var.subdomain

  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_route53_record" "subdomain-ns" {
  zone_id = "${aws_route53_zone.main-domain.zone_id}"
  name    = var.subdomain
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.main-subdomain.name_servers.0}",
    "${aws_route53_zone.main-subdomain.name_servers.1}",
    "${aws_route53_zone.main-subdomain.name_servers.2}",
    "${aws_route53_zone.main-subdomain.name_servers.3}",
  ]
}

# Wildcard cert for subdomain
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.subdomain}"
  validation_method = "DNS"

  tags = {
    Environment = var.environment_tag
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  name = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name

  zone_id = aws_route53_zone.main-subdomain.zone_id
  type = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = "60"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
  ]
}

