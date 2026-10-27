# artifacts/terraform/variables.tf

variable "project" {
  description = "프로젝트명(태그 Project 값)"
  type        = string
  default     = "geul"
}

variable "aws_region" {
  description = "기본 리전. geul-org 계정은 모든 리전 리소스를 us-east-1에 둔다"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI 프로필(geul-org 계정)"
  type        = string
  default     = "geul-org"
}

variable "domain" {
  description = "루트 도메인"
  type        = string
  default     = "geul.org"
}

variable "google_site_verification" {
  description = "Google Search Console 도메인 속성(sc-domain:geul.org) 인증 토큰. \"google-site-verification=\" 뒤의 값만 넣는다. terraform.tfvars(git 제외)로 공급한다. apex TXT를 이 값으로 덮어쓰므로 Route 53 실값과 반드시 일치시킬 것"
  type        = string

  validation {
    condition     = length(var.google_site_verification) > 0 && var.google_site_verification != "PLACEHOLDER"
    error_message = "실제 Google 인증 토큰을 넣어야 한다(PLACEHOLDER 불가)."
  }
}
