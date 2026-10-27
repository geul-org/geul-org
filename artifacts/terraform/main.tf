# artifacts/terraform/main.tf
#
# geul.org 인프라 — AWS 계정 geul-org(768075277121), 리전 us-east-1.
# 2026-10-27 개인 계정(062163939859)에서 이전했다. 기존 리소스는 CLI로 만든 뒤
# terraform import로 상태에 넣었다(plan = No changes 확인).
#
# 사용:
#   terraform init
#   terraform plan        # terraform.tfvars(git 제외)에 google_site_verification 필요

terraform {
  required_version = ">= 1.10.0"

  # 상태: geul-org 계정 us-east-1 버킷(버전 관리·SSE·공개 차단). 잠금은 S3 lockfile.
  # 이 버킷은 상태 저장소라 이 코드로 관리하지 않는다(닭과 달걀).
  backend "s3" {
    bucket       = "geul-org-tfstate-768075277121"
    key          = "geul-org/terraform.tfstate"
    region       = "us-east-1"
    profile      = "geul-org"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project = var.project
    }
  }
}

# ACM·CloudFront는 us-east-1이어야 한다. 기본 리전이 바뀌어도 고정되도록 별칭을 둔다.
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      Project = var.project
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  zone_id    = aws_route53_zone.main.zone_id
}
