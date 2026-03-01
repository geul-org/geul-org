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
│   ├── why/                         # "왜?" 시리즈 (21글)
│   │   ├── context-engineering/     # 컨텍스트 엔지니어링 (7글)
│   │   ├── artificial-language/     # 인공언어 (8글)
│   │   └── architecture/            # 아키텍처 (6글)
│   └── grammar/                     # 문법 명세 (12글)
│       └── verb-edge/               # 동사 엣지 (2글)
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

## 콘텐츠 현황

### Why 섹션 (21글, weight 순 = 목록 표시 순서)

#### 컨텍스트 엔지니어링 (context-engineering/, 7글)

| W | slug | 제목(ko) |
|---|------|----------|
| 1 | prompt-engineering-over | 왜 프롬프트 엔지니어링의 시대는 끝났는가 |
| 2 | rag-not-enough | 왜 RAG로는 부족한가 |
| 3 | clarification | 왜 명료화가 필요한가 |
| 4 | mechanical-verification | 왜 기계적 검증이 필요한가 |
| 5 | filter | 왜 필터가 필요한가 |
| 6 | consistency-check | 왜 정합성 검사가 필요한가 |
| 7 | exploration | 왜 탐색이 필요한가 |

#### 인공언어 (artificial-language/, 8글)

| W | slug | 제목(ko) |
|---|------|----------|
| 7 | artificial-language-needed | 왜 인공언어가 필요한가 |
| 8 | natural-language-hallucination | 왜 자연어는 환각을 만드는가 |
| 9 | not-md-json-xml | 왜 MD/JSON/XML로는 안 되는가 |
| 10 | not-programming-language | 왜 프로그래밍 언어로는 부족한가 |
| 11 | not-embedding-vector | 왜 임베딩 벡터로는 안 되는가 |
| 12 | esperanto-failed | 왜 에스페란토는 실패했는가 |
| 13 | wikidata | 왜 위키데이터인가 |
| 14 | wordnet | 왜 워드넷인가 |

#### 아키텍처 (architecture/, 6글)

| W | slug | 제목(ko) |
|---|------|----------|
| 15 | claims-not-facts | 왜 사실이 아니라 주장인가 |
| 16 | semantically-aligned-index | 왜 의미정렬 인덱스인가 |
| 17 | 16-bit | 왜 16비트인가 |
| 18 | structured-memory | 왜 구조화된 기억이 필요한가 |
| 19 | cache-reasoning-as-code | 왜 추론을 코드로 캐시하는가 |
| 20 | annotation-as-index | 왜 주석이 인덱스여야 하는가 |

### Grammar 섹션 (12글)

| W | slug | 제목(ko) |
|---|------|----------|
| 10 | verb-edge/_index | 동사 엣지 (카테고리) |
| 10 | verb-edge/semantic-role | 참여자 역할 |
| 20 | verb-edge/qualifier | 의미 한정자 |
| 20 | entity-node | 엔티티 노드 |
| 30 | triple-edge | 트리플 엣지 |
| 40 | clause-edge | 절 엣지 |
| 50 | event6-edge | 이벤트6 엣지 |
| 60 | context-edge | 컨텍스트 엣지 |
| 70 | quantity-node | 수량 노드 |
| 80 | ast-edge | AST 엣지 |
| 90 | group-edge | 그룹 엣지 |
| 100 | stream-format | 스트림 포맷 |

### Draft (미발행 초안)

| 파일명 | 비고 |
|--------|------|
| why-must-reserved.md | 예약 영역 |

발행 완료된 원본은 `draft/published/`에 보관.

## 게시 절차

사용자가 `draft/`에 초안을 올리면 아래 순서대로 실행한다. 계획 수립 불필요.

1. **소스 읽기:** `draft/`에서 원본 확인, 카테고리·slug·weight 결정
2. **한국어 원본 생성:** `content/ko/{section}/{category}/{slug}.md`
   - front matter 작성 (title, weight, date, lastmod, tags, summary, author, authorLink, image)
   - H1 제거(템플릿 자동), `##`부터 시작, 저자 서명·시리즈 라인 제거
3. **11개 언어 번역:** `content/{en,zh,es,ar,pt,id,ru,ja,fr,de,he}/{section}/{category}/{slug}.md`
   - 동일 slug, 동일 weight, 동일 front matter 구조
   - 기술 용어(GEUL, LLVM IR, LLM 등) 영문 유지
   - 문화적 예시 현지화 (인물, 인사말, 역사 출처)
   - author: en/es/pt/id/fr/de="Junwoo Park", ko="박준우", zh/ja="朴俊宇", ar="جونو بارك", ru="Джунву Пак", he="ג'ונו פארק"
4. **발행:** 원본을 `draft/published/`로 이동 후 `make publish` 실행
   - `make publish` = deploy(빌드→S3→CF무효화→IndexNow) + sitemap-ping(GSC) + archive(Wayback)
5. **커밋 & 푸시:** `git add` → `git commit` → `git push origin master`
6. **CLAUDE.md 업데이트:** 콘텐츠 현황 표에 새 글 추가

## Front Matter

```yaml
---
title: "Title"
weight: 7
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
make serve        # hugo server -D
make build        # hugo --minify → public/
make clean        # rm -rf public/
make deploy       # build + S3 sync + XML content-type fix + CF invalidation + IndexNow
make sitemap-ping # Google Search Console 사이트맵 재제출
make archive      # en sitemap URL → Wayback Machine 제출
make publish      # deploy + sitemap-ping + archive 일괄 실행
```

`CF_DIST_ID`는 Makefile에 기본값 설정됨 (`E2Z17ZOR6DJTRZ`)

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

`make deploy` 시 자동 제출 (설정 완료).

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
