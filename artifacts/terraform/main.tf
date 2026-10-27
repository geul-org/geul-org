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

# 메일: Google Workspace(Gmail)로 주고받는다(2026-10-27 재개; 같은 날 잠시 전면 차단했다가 되돌림).
# - 수신: Gmail MX 5개(TTL 3600; 원래 604800이었으나 변경 반영이 빠르도록 낮춤).
# - 발신: apex TXT SPF "v=spf1 include:_spf.google.com ~all".
# - DMARC: p=none(관찰). DKIM 미설정 상태라 정렬 실패 메일이 거부되지 않게 했다.
# 남은 일:
#   1) DKIM: Google 관리 콘솔에서 2048비트·선택자 google로 생성한 값을
#      google._domainkey TXT로 추가하고 인증을 시작한다(아직 레코드 없음).
#   2) 보고 수신함을 정하면 DMARC에 rua=mailto:<주소>@geul.org를 추가한다.
#   3) DKIM 정상 확인 후 DMARC를 p=quarantine → p=reject로 올린다.

# apex TXT RRset 전체(Google Search Console 도메인 인증 + SPF).
# 이 리소스가 apex TXT를 통째로 관리하므로 apex TXT 값은 모두 여기에 둔다.
resource "aws_route53_record" "txt_google_verification" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = 300

  records = [
    "google-site-verification=${var.google_site_verification}",
    "v=spf1 include:_spf.google.com ~all",
  ]
}

# DMARC: DKIM 설정 전까지 관찰만(p=none, 완화 정렬)
resource "aws_route53_record" "txt_dmarc" {
  zone_id = local.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DMARC1; p=none; adkim=r; aspf=r",
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
