# geul.org

GEUL(General Encoding Unified Language) 프로젝트 공식 웹사이트. Hugo 정적 사이트, 12개 언어, S3+CloudFront 배포.

**Author:** 박준우 (mail@parkjunwoo.com)
**License:** MIT
**GitHub:** [geul-org](https://github.com/geul-org)

---

## Languages (12)

en(기본, URL prefix 없음), ko, zh, es, ar(**RTL**), pt, id, ru, ja, fr, de, he(**RTL**)

## 게시 절차

사용자가 `files/draft/`에 초안을 올리면 아래 순서대로 실행한다. 계획 수립 불필요.

1. **소스 읽기:** `files/draft/`에서 원본 확인, 카테고리·slug·weight 결정
2. **한국어 원본 생성:** `artifacts/hugo/content/ko/{section}/{category}/{slug}.md`
   - front matter 작성 (title, weight, date, lastmod, tags, summary, author, authorLink, image)
   - H1 제거(템플릿 자동), `##`부터 시작, 저자 서명·시리즈 라인 제거
3. **11개 언어 번역:** `artifacts/hugo/content/{en,zh,es,ar,pt,id,ru,ja,fr,de,he}/{section}/{category}/{slug}.md`
   - 동일 slug, 동일 weight, 동일 front matter 구조
   - 기술 용어(GEUL, LLVM IR, LLM 등) 영문 유지
   - 문화적 예시 현지화 (인물, 인사말, 역사 출처)
   - author: en/es/pt/id/fr/de="Junwoo Park", ko="박준우", zh/ja="朴俊宇", ar="جونو بارك", ru="Джунву Пак", he="ג'ונו פארק"
4. **발행:** 원본을 `files/draft/published/`로 이동 후 `make publish` 실행
   - `make publish` = deploy(빌드→S3→CF무효화→IndexNow) + sitemap-ping(GSC) + archive(Wayback)
5. **커밋 & 푸시:** `git add` → `git commit` → `git push origin master`

## Commands

Hugo 경로: `~/bin/hugo` · Hugo 작업 디렉토리: `artifacts/hugo/`

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

## URL Convention

`/why/natural-language-hallucination/` (en) · `/{lang}/why/natural-language-hallucination/` (기타)

슬러그: 영문 소문자 하이픈, 관사 제거, 3~5단어, 모든 언어 동일 파일명

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
6. **커밋:** Co-Authored-By 트레일러 넣지 않는다. 커밋·푸시 전 민감정보(키, 토큰, 비밀번호)와 불필요한 파일(빌드 산출물, 로그) 포함 여부를 확인한다
