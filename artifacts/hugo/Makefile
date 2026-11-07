HUGO := /home/parkjunwoo/bin/hugo
INDEXNOW_KEY := 0494350ef009402ca25b3468df03ca58
DOMAIN := https://geul.org
# AWS: geul-org 계정(768075277121), 리전 us-east-1(2026-10-27 개인 계정에서 이전)
AWS_PROFILE ?= geul-org
AWS_REGION ?= us-east-1
AWS := aws --profile $(AWS_PROFILE) --region $(AWS_REGION)
S3_BUCKET ?= geul-org-public-768075277121
CF_DIST_ID ?= E2G25D5G8IOTHZ
GSC_SITE := sc-domain%3Ageul.org
GSC_SCOPE := https://www.googleapis.com/auth/webmasters
# GEUL 공표 아카이브(/.well-known/geul/): Issuer별 pack 세트(latest.txt, m/, o/)를 그대로 올린다.
# 허용 Issuer 세트만 ARCHIVE_TMP로 옮겨 검사한 뒤 올린다(../scripts/archive-files.sh). 뷰어 HTML(geul build 출력)은 올리지 않는다.
# Issuer 목록 issuers/는 0x00000000 세트에 들어 있다. 위키데이터(0x00000001)는 ARCHIVE_ISSUERS에 넣어도 ARCHIVE_DENY가 막는다.
GEUL ?= geul
ARCHIVE_REPO := ../../../../2-areas
ARCHIVE_TMP ?= $(CURDIR)/resources/geul-archive
ARCHIVE_DST := s3://$(S3_BUCKET)/.well-known/geul
ARCHIVE_ISSUERS ?= 0x00000000
ARCHIVE_DENY ?= 0x00000001
ARCHIVE_MAX_BYTES ?= 104857600
ARCHIVE_MAX_FILES ?= 1000
ARCHIVE_STAGE := $(ARCHIVE_TMP)/src/.well-known/geul

.PHONY: serve build clean deploy deploy-archive deploy-archive-dryrun archive-stage indexnow archive sitemap-ping publish validate

serve:
	$(HUGO) server -D

build:
	$(HUGO) --minify

clean:
	rm -rf public/

deploy: build
	$(AWS) s3 sync public/ s3://$(S3_BUCKET)/ --delete --exact-timestamps --exclude ".well-known/*"
	$(AWS) s3 cp s3://$(S3_BUCKET)/ s3://$(S3_BUCKET)/ --recursive --exclude "*" --include "*.xml" --exclude ".well-known/*" --content-type "application/xml; charset=utf-8" --metadata-directive REPLACE
	$(AWS) cloudfront create-invalidation --distribution-id $(CF_DIST_ID) --paths "/*"
	@$(MAKE) indexnow

# 아카이브는 Hugo 동기화(deploy)와 따로 올린다. deploy의 --delete는 .well-known/*를 건드리지 않는다.
# archive-stage: 허용 Issuer 세트를 ARCHIVE_TMP로 옮기고 검사한다. 목록이 비거나, 허용 밖·위키데이터 Issuer가 섞이거나,
#   상한(ARCHIVE_MAX_BYTES·ARCHIVE_MAX_FILES)을 넘거나, geul pack verify·check --archive가 실패하면 업로드 전에 멈춘다.
archive-stage:
	ARCHIVE_ISSUERS="$(ARCHIVE_ISSUERS)" ARCHIVE_DENY="$(ARCHIVE_DENY)" ARCHIVE_MAX_BYTES=$(ARCHIVE_MAX_BYTES) \
	ARCHIVE_MAX_FILES=$(ARCHIVE_MAX_FILES) GEUL=$(GEUL) ../scripts/archive-files.sh $(ARCHIVE_REPO)/.well-known/geul $(ARCHIVE_TMP)

# 드라이런: 올릴 목록(크기, 경로)과 원격과의 차이만 보인다(s3 sync --dryrun, 읽기만).
deploy-archive-dryrun: archive-stage
	@cat $(ARCHIVE_TMP)/files.lst
	@for i in $(ARCHIVE_ISSUERS); do \
		echo "== $$i latest.txt: $$(cat $(ARCHIVE_STAGE)/$$i/latest.txt)"; \
		$(AWS) s3 sync $(ARCHIVE_STAGE)/$$i/ $(ARCHIVE_DST)/$$i/ --delete --dryrun || exit 1; \
	done

# Issuer 폴더마다 따로 sync해 원격의 다른 Issuer 폴더는 건드리지 않는다.
# 순서: 새 객체(m/, o/, 불변) → latest.txt(세대 전환, no-cache) → 원격에만 남은 옛 객체 삭제
deploy-archive: archive-stage
	@set -e; for i in $(ARCHIVE_ISSUERS); do \
		$(AWS) s3 sync $(ARCHIVE_STAGE)/$$i/ $(ARCHIVE_DST)/$$i/ --exclude latest.txt \
			--content-type application/octet-stream --cache-control "public, max-age=31536000, immutable"; \
		$(AWS) s3 cp $(ARCHIVE_STAGE)/$$i/latest.txt $(ARCHIVE_DST)/$$i/latest.txt \
			--content-type "text/plain; charset=utf-8" --cache-control no-cache; \
		$(AWS) s3 sync $(ARCHIVE_STAGE)/$$i/ $(ARCHIVE_DST)/$$i/ --exclude latest.txt --delete \
			--content-type application/octet-stream --cache-control "public, max-age=31536000, immutable"; \
	done
	$(AWS) cloudfront create-invalidation --distribution-id $(CF_DIST_ID) --paths "/.well-known/geul/*"

indexnow:
	@echo "Submitting URLs to IndexNow..."
	@URLS=$$(grep -oP '(?<=<loc>)[^<]+' public/sitemap.xml 2>/dev/null); \
	if [ -z "$$URLS" ]; then echo "No URLs found in sitemap.xml"; exit 0; fi; \
	URL_LIST=$$(echo "$$URLS" | head -10000 | sed 's/.*/"&"/' | paste -sd, | sed 's/^/[/;s/$$/]/'); \
	curl -s -X POST "https://api.indexnow.org/indexnow" \
		-H "Content-Type: application/json" \
		-d "{\"host\":\"geul.org\",\"key\":\"$(INDEXNOW_KEY)\",\"keyLocation\":\"$(DOMAIN)/$(INDEXNOW_KEY).txt\",\"urlList\":$$URL_LIST}" \
		-w "\nHTTP %{http_code}\n"; \
	echo "Done."

sitemap-ping:
	@echo "Pinging Google Search Console..."
	@TOKEN=$$(gcloud auth print-access-token --scopes=$(GSC_SCOPE) 2>/dev/null); \
	if [ -z "$$TOKEN" ]; then \
		echo "  Activating service account..."; \
		gcloud auth activate-service-account claude-code@claribot-488401.iam.gserviceaccount.com \
			--key-file=~/.config/gcloud/claude-code-sa-key.json 2>/dev/null; \
		TOKEN=$$(gcloud auth print-access-token --scopes=$(GSC_SCOPE)); \
	fi; \
	CODE=$$(curl -s -o /dev/null -w "%{http_code}" \
		-X PUT -H "Authorization: Bearer $$TOKEN" \
		"https://searchconsole.googleapis.com/webmasters/v3/sites/$(GSC_SITE)/sitemaps/https%3A%2F%2Fgeul.org%2Fsitemap.xml"); \
	echo "  GSC sitemap ping: HTTP $$CODE"; \
	echo "Done."

archive:
	@echo "Submitting to Wayback Machine (en only)..."
	@URLS=$$(grep -oP '(?<=<loc>)[^<]+' public/en/sitemap.xml 2>/dev/null); \
	if [ -z "$$URLS" ]; then echo "No URLs found. Run 'make build' first."; exit 1; fi; \
	TOTAL=$$(echo "$$URLS" | wc -l); N=0; \
	for url in $$URLS; do \
		N=$$((N+1)); \
		CODE=$$(curl -s -o /dev/null -w "%{http_code}" "https://web.archive.org/save/$$url"); \
		echo "  [$$N/$$TOTAL] $$CODE $$url"; \
		sleep 10; \
	done; \
	echo "Wayback Machine done."

validate:
	python3 ../scripts/validate-frontmatter.py

publish: validate deploy sitemap-ping archive
