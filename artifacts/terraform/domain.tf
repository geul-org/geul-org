# artifacts/terraform/domain.tf
#
# 도메인 등록 geul.org(Route 53 Domains, 등록 대행 Gandi). 2026-10-27 개인 계정에서
# TransferDomainToAnotherAwsAccount로 넘겨받았다(무료, 만료일 불변).
# 이 리소스는 기존 등록을 관리만 한다: destroy해도 도메인은 삭제되지 않고 상태에서 빠진다.
# 연락처(admin/registrant/tech/billing)는 개인정보라 코드에 두지 않는다(실값 유지, computed).

resource "aws_route53domains_registered_domain" "main" {
  provider    = aws.us_east_1
  domain_name = var.domain

  auto_renew    = true
  transfer_lock = true

  # 등록처에 넣은 순서 그대로(= 호스팅 영역 위임 집합 순서). 영역의 name_servers 출력은
  # 정렬돼 있어 순서 차이가 diff로 나오므로 명시한다. 영역을 다시 만들면 함께 고친다.
  dynamic "name_server" {
    for_each = local.delegation_name_servers
    content {
      name = name_server.value
    }
  }
}

locals {
  delegation_name_servers = [
    "ns-604.awsdns-11.net",
    "ns-1770.awsdns-29.co.uk",
    "ns-1111.awsdns-10.org",
    "ns-102.awsdns-12.com",
  ]
}

check "domain_ns_match_zone" {
  assert {
    condition     = toset(local.delegation_name_servers) == toset(aws_route53_zone.main.name_servers)
    error_message = "도메인 네임서버가 호스팅 영역 NS와 다르다."
  }
}
