# deployments/terraform/variables.tf

variable "project" {
  description = "프로젝트명, 예: geul"
  type        = string
}

variable "aws_region" {
  description = "예: ap-northeast-2"
  type        = string
}

variable "domain" {
  description = "루트 도메인, 예: geul.org"
  type        = string
}

variable "google_site_verification" {
  description = "Google Search Console 도메인 속성(sc-domain:geul.org) 인증 토큰. \"google-site-verification=\" 뒤의 값만 넣는다. Search Console > 설정 > 소유권 확인에서 확인. apply 시 apex TXT를 이 값으로 덮어쓰므로 Route 53 실값과 반드시 일치시킬 것"
  type        = string

  validation {
    condition     = length(var.google_site_verification) > 0 && var.google_site_verification != "PLACEHOLDER"
    error_message = "실제 Google 인증 토큰을 넣어야 한다(PLACEHOLDER 불가)."
  }
}
