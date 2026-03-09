HUGO := /home/parkjunwoo/bin/hugo
INDEXNOW_KEY := 0494350ef009402ca25b3468df03ca58
DOMAIN := https://geul.org
CF_DIST_ID ?= E2Z17ZOR6DJTRZ
GSC_SITE := sc-domain%3Ageul.org
GSC_SCOPE := https://www.googleapis.com/auth/webmasters

.PHONY: serve build clean deploy indexnow archive sitemap-ping publish validate

serve:
	$(HUGO) server -D

build:
	$(HUGO) --minify

clean:
	rm -rf public/

deploy: build
	aws s3 sync public/ s3://geul-org-public/ --delete --exact-timestamps
	aws s3 cp s3://geul-org-public/ s3://geul-org-public/ --recursive --exclude "*" --include "*.xml" --content-type "application/xml; charset=utf-8" --metadata-directive REPLACE
	aws cloudfront create-invalidation --distribution-id $(CF_DIST_ID) --paths "/*"
	@$(MAKE) indexnow

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
