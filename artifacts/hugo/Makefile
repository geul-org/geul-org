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
# GEUL 공표 아카이브(/.well-known/geul/): git 추적 파일 + 아직 커밋하지 않은 규격 문서와 그 h/ 사본만 geul build로 구워 올린다
# (목록은 ../scripts/archive-files.sh, 위키데이터 변환 문서 제외)
GEUL ?= geul
ARCHIVE_REPO := ../geul
ARCHIVE_TMP ?= $(CURDIR)/resources/geul-archive
ARCHIVE_DST := s3://$(S3_BUCKET)/.well-known/geul/

.PHONY: serve build clean deploy deploy-archive indexnow archive sitemap-ping publish validate

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
# <path>.geul = 원본 바이트(application/vnd.geul), 확장자 없는 <path>·index.html = 뷰어(text/html), index.json = 목록
deploy-archive:
	rm -rf $(ARCHIVE_TMP) && mkdir -p $(ARCHIVE_TMP)/src
	GEUL=$(GEUL) ../scripts/archive-files.sh $(ARCHIVE_REPO) > $(ARCHIVE_TMP)/files.lst
	cd $(ARCHIVE_REPO) && xargs -0 cp --parents -t $(ARCHIVE_TMP)/src < $(ARCHIVE_TMP)/files.lst
	@if tr '\0' '\n' < $(ARCHIVE_TMP)/files.lst | grep -q '0x0001000[01]/'; then echo "wikidata documents in the archive list" >&2; exit 1; fi
	$(GEUL) build -o $(ARCHIVE_TMP)/out $(ARCHIVE_TMP)/src
	$(AWS) s3 sync $(ARCHIVE_TMP)/out/.well-known/geul/ $(ARCHIVE_DST) --delete --exclude "*" --include "*.geul" --content-type "application/vnd.geul"
	$(AWS) s3 sync $(ARCHIVE_TMP)/out/.well-known/geul/ $(ARCHIVE_DST) --delete --exclude "*" --include "*.json" --content-type "application/json; charset=utf-8"
	$(AWS) s3 sync $(ARCHIVE_TMP)/out/.well-known/geul/ $(ARCHIVE_DST) --delete --exclude "*" --include "_static/*"
	$(AWS) s3 sync $(ARCHIVE_TMP)/out/.well-known/geul/ $(ARCHIVE_DST) --delete --exclude "*.geul" --exclude "*.json" --exclude "_static/*" --content-type "text/html; charset=utf-8"
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
