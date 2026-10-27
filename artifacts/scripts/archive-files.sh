#!/usr/bin/env bash
# GEUL 공표 아카이브에서 올릴 파일 목록을 NUL 구분으로 낸다(경로는 아카이브 루트 기준).
#   1. git이 추적하고 작업 트리에 있는 파일(--amend로 지운 옛 h/ 사본은 빠진다)
#   2. 아직 추적하지 않았고 무시 대상도 아닌 파일(새 규격 문서; 위키데이터 0x00010000·0x00010001과 h/*는 무시 대상)
#   3. 위키데이터 문서를 뺀 모든 문서의 내용 해시 사본 h/<hash>.geul(커밋 전의 새 규격 문서 사본 포함)
# 위키데이터 변환 문서와 그 h/ 사본은 넣지 않는다.
set -euo pipefail
root=${1:?usage: archive-files.sh ARCHIVE_ROOT}
geul=${GEUL:-geul}
cd "$root"
{
	git ls-files --cached -- .well-known/geul | while IFS= read -r f; do
		if [ -f "$f" ]; then printf '%s\n' "$f"; fi
	done
	git ls-files --others --exclude-standard -- .well-known/geul
	find .well-known/geul -name '*.geul' -not -path '.well-known/geul/h/*' \
		-not -path '.well-known/geul/0x00010000/*' -not -path '.well-known/geul/0x00010001/*' | while IFS= read -r f; do
		h=$("$geul" hash "$f")
		if [ -f ".well-known/geul/h/$h.geul" ]; then printf '%s\n' ".well-known/geul/h/$h.geul"; fi
	done
} | sed 's|^\./||' | sort -u | tr '\n' '\0'
