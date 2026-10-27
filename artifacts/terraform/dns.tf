# artifacts/terraform/dns.tf
#
# Route 53 호스팅 영역 geul.org와 레코드 전부(NS·SOA 제외).
# 도메인 등록(registered_domain)의 네임서버가 이 영역의 NS를 가리킨다(domain.tf).

resource "aws_route53_zone" "main" {
  name    = var.domain
  comment = "geul.org (migrated from personal account 2026-10-27)"
}

# 메일: Google Workspace(Gmail)로 주고받는다(2026-10-27 재개).
# - 수신: Gmail MX 5개(TTL 3600).
# - 발신: apex TXT SPF "v=spf1 include:_spf.google.com ~all".
# - DKIM: google._domainkey(2048비트, 선택자 google).
# - DMARC: p=none(관찰).
# 남은 일:
#   1) 보고 수신함을 정하면 DMARC에 rua=mailto:<주소>@geul.org를 추가한다.
#   2) DKIM 정상 확인 후 DMARC를 p=quarantine → p=reject로 올린다.

# apex TXT RRset 전체(Google Search Console 도메인 인증 + SPF).
# 이 리소스가 apex TXT를 통째로 관리하므로 apex TXT 값은 모두 여기에 둔다.
resource "aws_route53_record" "txt_apex" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = 300

  records = [
    "google-site-verification=${var.google_site_verification}",
    "v=spf1 include:_spf.google.com ~all",
  ]
}

# DMARC: 관찰만(p=none, 완화 정렬)
resource "aws_route53_record" "txt_dmarc" {
  zone_id = local.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DMARC1; p=none; adkim=r; aspf=r",
  ]
}

# DKIM 공개키(Google 관리 콘솔에서 생성). 255자 넘는 TXT는 `\" \"`로 문자열을 나눈다(Route 53 저장 형식).
resource "aws_route53_record" "txt_dkim_google" {
  zone_id = local.zone_id
  name    = "google._domainkey.${var.domain}"
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAycOaVdjP681nKDmYpyiwp04mzKq1o2vfVEAxtnBye/Q45zWhy9tqTzArtpa+pDQcjouQEXIgwwM7FEVEyEhIlKJsN5VvGcbIhfJEiR0FIlARSpq3/M+onmBf1OwAgQtNoIAkRhRDZUK6TqbIZhKLQps2pdsGvFwk1+/nIOgbjJMJRc2nyV2IH/Xd1It6\" \"c8vkiANFnUqrwNOl+cDMv/ltpwbXGZUluq1dQ8UGZj3plsOJFjy6sctLxaGjmYHZ3ajJ63Mb+Bgv7kkogIpGCplFVFhEhrWtpZwrbNDPTS8yKlZJAGZF2Vp1P+Uh4gbUHNvFwhNW2pMCB+AsqLP/pkveKQIDAQAB",
  ]
}

# Gmail MX 레코드
resource "aws_route53_record" "mx_gmail" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = 3600

  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]
}

# apex·www → CloudFront
resource "aws_route53_record" "a_apex" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn_public.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_public.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "a_www" {
  zone_id = local.zone_id
  name    = local.public_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn_public.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_public.hosted_zone_id
    evaluate_target_health = false
  }
}

# CloudFront 별칭 이전 확인용 TXT(_<별칭> → 배포 도메인). associate-alias로
# 별칭을 다른 배포로 옮길 때 CloudFront가 이 레코드를 확인한다.
resource "aws_route53_record" "txt_cf_alias_apex" {
  zone_id = local.zone_id
  name    = "_.${var.domain}"
  type    = "TXT"
  ttl     = 300
  records = [aws_cloudfront_distribution.cdn_public.domain_name]
}

resource "aws_route53_record" "txt_cf_alias_www" {
  zone_id = local.zone_id
  name    = "_${local.public_domain}"
  type    = "TXT"
  ttl     = 300
  records = [aws_cloudfront_distribution.cdn_public.domain_name]
}
