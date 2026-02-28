# geul.org

GEUL 프로젝트 공식 웹사이트. Hugo 정적 사이트, 12개 언어, S3+CloudFront 배포.

**Author:** 박준우 (mail@parkjunwoo.com)
**License:** MIT
**관련 레포:** [geul](https://github.com/park-jun-woo/geul) · [geul-sidx](https://github.com/park-jun-woo/geul-sidx) · [silk](https://github.com/park-jun-woo/silk)

---

## Languages (12)

en(기본, URL prefix 없음), ko, zh, es, ar(**RTL**), pt, id, ru, ja, fr, de, he(**RTL**)

## 프로젝트 구조

```
geul-org/
├── hugo.toml / Makefile
├── content/{en,ko,zh,es,ar,pt,id,ru,ja,fr,de,he}/
│   ├── _index.md                    # 홈
│   ├── repos/                       # GitHub 저장소 목록
│   └── why/                         # "왜?" 시리즈 (16글)
│       ├── architecture/            # 아키텍처 (5글)
│       ├── artificial-language/     # 인공언어 (6글)
│       └── context-engineering/     # 컨텍스트 엔지니어링 (7글)
├── layouts/                         # 외부 테마 없음
│   ├── index.html                   # 홈
│   ├── _default/{baseof,single,list,languages}.html
│   ├── _default/_markup/render-link.html  # 링크 렌더러 (noopener)
│   ├── partials/{head,header,footer,schema}.html
│   ├── why/list.html
│   ├── robots.txt / 404.html
├── assets/css/main.css              # 라이트 테마, Noto Serif, RTL, 반응형
├── static/images/                   # WebP OG 이미지
├── deployments/terraform/
└── public/                          # Hugo 출력 (.gitignore)
```

## Front Matter

```yaml
---
title: "Title"
date: 2026-02-26T12:00:00+09:00
lastmod: 2026-02-26T12:00:00+09:00
tags: ["tag1", "tag2"]
summary: "Meta description용 1문단 요약 (한글 ~80자, 영문 ~155자)"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---
```

## Commands

Hugo 경로: `/home/parkjunwoo/bin/hugo`

```bash
make serve     # hugo server -D
make build     # hugo --minify → public/
make clean     # rm -rf public/
make deploy    # build + S3 sync + XML content-type fix + CF invalidation + IndexNow
```

배포 시 `CF_DIST_ID=E2Z17ZOR6DJTRZ make deploy`

## AWS Deployment

```
Route53 (geul.org, www) → CloudFront (E2Z17ZOR6DJTRZ) → S3 (geul-org-public) via OAC
```

| 서비스 | 리소스 | 비고 |
|--------|--------|------|
| S3 | `geul-org-public` / `geul-logs` | 사이트 호스팅 (OAC) / 로그 (90일) |
| CloudFront | `E2Z17ZOR6DJTRZ` | HTTPS redirect, CachingOptimized, 압축 |
| CF Function | `geul-public-router` | 언어 감지(cookie→Accept-Language) + clean URL |
| ACM | `www.geul.org` + SAN `geul.org` | us-east-1 |
| Route53 | `geul.org` zone (`Z09654152WX7070IWCD4A`) | A×2(apex+www→CF), TXT(Google 인증) |
| IAM | `geul-deployer` | S3 sync + CF invalidation |

**Terraform** (`deployments/terraform/`): Region ap-northeast-2 / us-east-1(CF,ACM)

## IndexNow

Makefile에 `INDEXNOW_KEY` 미설정 (TODO). 설정 후 `make deploy` 시 자동 제출.

## URL Convention

`/why/natural-language-hallucination/` (en) · `/{lang}/why/natural-language-hallucination/` (기타)

슬러그: 영문 소문자 하이픈, 관사 제거, 3~5단어, 모든 언어 동일 파일명

## Cross-linking

geul.org ↔ parkjunwoo.com 상호 백링크 (SEO)
- footer → `parkjunwoo.com/1/en/about/` · Repos · Languages

## Google Search Console

- GCP: `claribot-488401` | SA: `claude-code@claribot-488401.iam.gserviceaccount.com`
- SA 키: `~/.config/gcloud/claude-code-sa-key.json`
- 사이트: `sc-domain:geul.org` (DNS TXT 인증 완료, SA=siteOwner)
- 소유자: SA + `mail@parkjunwoo.com`
- 사이트맵: `https://geul.org/sitemap.xml` (제출 완료)

```bash
# SA 활성화
gcloud auth activate-service-account claude-code@claribot-488401.iam.gserviceaccount.com \
  --key-file=~/.config/gcloud/claude-code-sa-key.json
# 검색 실적 조회
curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token --scopes=https://www.googleapis.com/auth/webmasters)" \
  -H "Content-Type: application/json" \
  -d '{"startDate":"2026-02-01","endDate":"2026-02-26","dimensions":["query"],"rowLimit":10}' \
  "https://searchconsole.googleapis.com/webmasters/v3/sites/sc-domain%3Ageul.org/searchAnalytics/query"
```

## SEO 체크리스트

- `<title>` = `{글 제목} — {사이트 제목}` (head.html)
- `<meta name="description">` = frontmatter `summary`
- H1은 템플릿(single.html)에서 자동 생성 → 마크다운에 `#` 사용 금지, `##`부터 시작
- OG: `og:title`, `og:description`, `og:image`(frontmatter `image:`), `og:locale`
- twitter:card: 이미지 있으면 `summary_large_image`, 없으면 `summary`
- Schema.org: Article(headline, date, author, image) + BreadcrumbList
- hreflang: 12개 언어 + `x-default`(en) 자동 생성
- canonical URL 자동
- taxonomy(tags) 페이지: `noindex, follow`
- CSS minify + fingerprint

---

## 작업 규칙

1. **문서 언어:** 한국어 우선, 기술 용어는 영문 병기
2. **H1 금지:** 마크다운 콘텐츠에서 `#` 사용 금지, `##`부터 시작 (H1은 템플릿 자동 생성)
3. **슬러그 규칙:** 영문 소문자 하이픈, 관사 제거, 3~5단어, 모든 언어 동일 파일명
4. **이미지:** WebP 포맷, static/images/에 저장
5. **RTL 언어:** ar, he는 RTL 레이아웃 자동 적용 (CSS)
6. **커밋:** Co-Authored-By 트레일러 넣지 않는다
