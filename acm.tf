resource "aws_acm_certificate" "main" {
  provider = aws.useast1

  domain_name               = local.domain
  subject_alternative_names = ["*.${local.domain}"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "main" {
  provider = aws.useast1

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}
