# artifacts/terraform/public.tf
#
# 정적 사이트: S3(비공개, OAC) → CloudFront(+ 라우터 함수) → www.geul.org, geul.org

locals {
  public_domain      = "www.${var.domain}"
  public_bucket_name = "geul-org-public-${local.account_id}"
  log_bucket_name    = "geul-org-logs-${local.account_id}"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  provider = aws.us_east_1
  name     = "Managed-CachingOptimized"
}

# ---------------------------------------------------------------- ACM

# ACM 인증서(www.geul.org + geul.org). 검증 CNAME은 아래 acm_validation 레코드.
# aws_acm_certificate_validation은 실체가 없는 대기 리소스라 import할 수 없어 두지 않는다
# (인증서는 이미 ISSUED).
resource "aws_acm_certificate" "public" {
  provider                  = aws.us_east_1
  domain_name               = local.public_domain
  subject_alternative_names = [var.domain]
  validation_method         = "DNS"
  key_algorithm             = "RSA_2048"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for o in aws_acm_certificate.public.domain_validation_options : o.domain_name => o
  }

  zone_id = local.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 300
  records = [each.value.resource_record_value]
}

# ---------------------------------------------------------------- S3

# 사이트 버킷(비공개; CloudFront OAC만 읽는다)
resource "aws_s3_bucket" "public" {
  bucket = local.public_bucket_name
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket                  = aws_s3_bucket.public.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "public" {
  bucket = aws_s3_bucket.public.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "public" {
  bucket = aws_s3_bucket.public.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "public" {
  bucket = aws_s3_bucket.public.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled       = false
    blocked_encryption_types = ["SSE-C"]
  }
}

resource "aws_s3_bucket_policy" "public_oac" {
  bucket = aws_s3_bucket.public.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontOACRead"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn_public.arn
          }
        }
      }
    ]
  })
}

# CloudFront 표준 로그 버킷. CloudFront(레거시 로깅)가 ACL로 쓰므로 BucketOwnerPreferred.
# 버킷 ACL(awslogsdelivery FULL_CONTROL)은 CloudFront가 로깅 설정 시 직접 넣으므로
# 여기서 관리하지 않는다. 수명 주기 규칙 없음(이전 버킷과 동일).
resource "aws_s3_bucket" "logs" {
  bucket = local.log_bucket_name
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled       = false
    blocked_encryption_types = ["SSE-C"]
  }
}

# ---------------------------------------------------------------- CloudFront

resource "aws_cloudfront_origin_access_control" "public" {
  provider                          = aws.us_east_1
  name                              = local.public_bucket_name
  description                       = "OAC for geul.org public bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 뷰어 요청 라우터: /dsl 410, 홈 언어 리다이렉트(lang 쿠키 → Accept-Language), index.html 리라이트
resource "aws_cloudfront_function" "public_router" {
  provider = aws.us_east_1
  name     = "geul-public-router"
  runtime  = "cloudfront-js-2.0"
  comment  = "GEUL URL router"
  publish  = true
  code     = file("${path.module}/functions/cloudfront-public-router.js")
}

resource "aws_cloudfront_distribution" "cdn_public" {
  provider            = aws.us_east_1
  enabled             = true
  comment             = "geul.org public site"
  default_root_object = "index.html"
  aliases             = [local.public_domain, var.domain]
  price_class         = "PriceClass_All"
  http_version        = "http2"
  is_ipv6_enabled     = true

  logging_config {
    bucket          = aws_s3_bucket.logs.bucket_regional_domain_name
    prefix          = "cdn/"
    include_cookies = false
  }

  origin {
    origin_id                = aws_s3_bucket.public.id
    domain_name              = aws_s3_bucket.public.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.public.id
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.public.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.public_router.arn
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.public.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = 403
    response_page_path    = "/404.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }
  custom_error_response {
    error_code            = 404
    response_page_path    = "/404.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }
  custom_error_response {
    error_code            = 500
    response_page_path    = "/404.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn_public.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn_public.domain_name
}

output "public_bucket" {
  value = aws_s3_bucket.public.id
}

output "logs_bucket" {
  value = aws_s3_bucket.logs.id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}
