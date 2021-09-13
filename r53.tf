//resource "aws_route53_zone" "todot" {
//  name = "todo.be34.me"
//  tags = {
//    Environment = "todot"
//  }
//}

resource "aws_route53_record" "todot" {
  zone_id = "Z0836348GP5UU32LPO74" #aws_route53_zone.todot.id
  name    = "todo.be34.me"
  type    = "A"
  alias {
    name = aws_cloudfront_distribution.s3.domain_name
    zone_id = aws_cloudfront_distribution.s3.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  zone_id = "Z0836348GP5UU32LPO74" #aws_route53_zone.todot.id
  name    = "api.todo.be34.me"
  type    = "A"
  alias {
    name = aws_alb.default.dns_name
    zone_id = aws_alb.default.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "validation_alb" {
  allow_overwrite = true
  name = tolist(aws_acm_certificate.cert_alb.domain_validation_options)[0].resource_record_name
  records = [ tolist(aws_acm_certificate.cert_alb.domain_validation_options)[0].resource_record_value ]
  type = tolist(aws_acm_certificate.cert_alb.domain_validation_options)[0].resource_record_type
  zone_id = "Z0836348GP5UU32LPO74" #aws_route53_zone.todot.id
  ttl = 60
}

resource "aws_acm_certificate" "cert_alb" {
  domain_name = "todo.be34.me"
  subject_alternative_names = ["*.todo.be34.me"]
  validation_method = "DNS"

}

resource "aws_acm_certificate_validation" "cert_alb" {
  certificate_arn = aws_acm_certificate.cert_alb.arn
  validation_record_fqdns = [
    aws_route53_record.validation_alb.fqdn
  ]
}


resource "aws_route53_record" "validation" {
  provider = aws.acm
  allow_overwrite = true
  name = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [ tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value ]
  type = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = "Z0836348GP5UU32LPO74" #aws_route53_zone.todot.id
  ttl = 60
}

resource "aws_acm_certificate" "cert" {
  domain_name = "todo.be34.me"
  validation_method = "DNS"
  provider = aws.acm
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.acm
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.validation.fqdn
  ]
}

provider "aws" {
  alias = "acm"
  region = "us-east-1"
}