# deployments/terraform/main.tf

terraform {
  required_version = ">= 1.5.0"

  backend "s3" {}

  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.95.0" }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

locals {
  zone_id = data.aws_route53_zone.main.zone_id
  tags = {
    Project   = var.project
    Workspace = terraform.workspace
  }
}

# Route53 Hosted Zone (도메인 등록 시 자동 생성됨 — data source로 참조)
data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

# 메일: 이 도메인은 메일을 보내지 않는다(2026-10-27 결정, 의도적으로 발신 차단).
# - apex TXT의 SPF "v=spf1 -all": 어떤 서버도 geul.org 명의로 발신 불가.
# - _dmarc TXT "p=reject": SPF/DKIM 정렬 실패 메일은 수신 측이 거부. 보고 주소(rua/ruf) 없음.
# - MX: Gmail MX가 이미 있어 null MX("0 .", RFC 7505)는 넣지 않았다(수신은 그대로).
# 발신을 다시 켜려면(예: Google Workspace):
#   1) SPF를 "v=spf1 include:_spf.google.com ~all"로 바꾸고 DKIM(google._domainkey) TXT 추가,
#   2) DMARC를 p=none(+rua)으로 낮춰 관찰한 뒤 quarantine→reject로 올린다.
# 메일을 아예 받지도 않으려면 mx_gmail을 지우고 records = ["0 ."]인 null MX로 바꾼다.

# apex TXT RRset 전체(Google Search Console 도메인 인증 + SPF).
# 이 리소스가 apex TXT를 통째로 관리하므로 apex TXT 값은 모두 여기에 둔다.
resource "aws_route53_record" "txt_google_verification" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = 300

  records = [
    "google-site-verification=${var.google_site_verification}",
    "v=spf1 -all",
  ]
}

# DMARC: 메일 발신 없음 → 정렬 실패 전부 거부
resource "aws_route53_record" "txt_dmarc" {
  zone_id = local.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s",
  ]
}

# Gmail MX 레코드
resource "aws_route53_record" "mx_gmail" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = 86400 * 7

  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]
}
