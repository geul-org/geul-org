#!/usr/bin/env bash
# GEUL 공표 아카이브에서 올릴 pack 세트를 임시 폴더로 옮기고 검사한다. 업로드는 하지 않는다.
#   usage: archive-files.sh SRC TMP
#     SRC  아카이브의 .well-known/geul 폴더(읽기만 한다)
#     TMP  임시 폴더. TMP/src/.well-known/geul/<Issuer>/에 세트를, TMP/files.lst에 올릴 목록을 둔다
#   환경 변수
#     ARCHIVE_ISSUERS    올릴 Issuer(공백 구분, 기본 0x00000000). Issuer 목록 issuers/는 0x00000000 세트에 들어 있다
#     ARCHIVE_DENY       허용 목록에 있어도 막는 Issuer(기본 0x00000001, 위키데이터)
#     ARCHIVE_MAX_BYTES  올릴 크기 상한(바이트)
#     ARCHIVE_MAX_FILES  올릴 파일 수 상한
#     ARCHIVE_VMEM_KB    이 스크립트와 geul의 가상 메모리 상한(KB)
#     GEUL               geul 실행 파일
# 세트 폴더는 latest.txt, m/<sha256>.gpm, o/<sha256>.gpk·.gpx만 담아야 한다. 그 밖의 항목이 있으면 멈춘다.
# 허용 Issuer 폴더만 읽는다. SRC의 다른 Issuer 폴더(위키데이터 세트 등)는 열거하지 않는다.
set -euo pipefail

src=${1:?usage: archive-files.sh SRC TMP}
tmp=${2:?usage: archive-files.sh SRC TMP}
issuers=${ARCHIVE_ISSUERS:-0x00000000}
deny=${ARCHIVE_DENY:-0x00000001}
max_bytes=${ARCHIVE_MAX_BYTES:-104857600}
max_files=${ARCHIVE_MAX_FILES:-1000}
geul=${GEUL:-geul}
ulimit -v "${ARCHIVE_VMEM_KB:-4000000}"

fail() { echo "archive-files: $*" >&2; exit 1; }

# 사용자 설정 파일과 GEULPROXY를 끈다. geul이 임시 폴더 밖(아카이브 전체 등)을 읽지 않게 한다.
export GEULENV=/dev/null GEULPROXY=off GEULPACK= GEULDATA= GEULCACHE="$tmp/cache" GEULFORMAT=text

# canon은 Issuer ID의 앞 0을 떼어 같은 Issuer를 같은 값으로 만든다(0x00000001 = 0x0000000000000001).
canon() { local h; h=$(printf '%s' "${1#0x}" | sed 's/^0*//'); echo "${h:-0}"; }

[ -d "$src" ] || fail "$src: no such folder"
src_abs=$(realpath "$src")
tmp_abs=$(realpath -m "$tmp")
case "$tmp_abs/" in "$src_abs"/*) fail "TMP $tmp_abs is inside SRC" ;; esac
case "$src_abs/" in "$tmp_abs"/*) fail "TMP $tmp_abs holds SRC" ;; esac
[ "$tmp_abs" != / ] && [ "$tmp_abs" != "$HOME" ] || fail "TMP $tmp_abs refused"

# 1. Issuer 목록 검사: 비었는지, 표기, 금지 Issuer, 중복
[ -n "${issuers// /}" ] || fail "ARCHIVE_ISSUERS is empty"
declare -A allow=()
for i in $issuers; do
	[[ $i =~ ^0x([0-9A-F]{8}|[0-9A-F]{16}|[0-9A-F]{64})$ ]] || fail "$i: not an Issuer ID (0x + 8, 16 or 64 upper-case hex digits)"
	for d in $deny; do
		[ "$(canon "$i")" != "$(canon "$d")" ] || fail "$i: denied Issuer (ARCHIVE_DENY)"
	done
	[ -z "${allow[$(canon "$i")]:-}" ] || fail "$i: listed twice"
	allow[$(canon "$i")]=$i
	[ -f "$src/$i/latest.txt" ] || fail "$src/$i: no pack set (latest.txt)"
done

# check_set은 세트 폴더 하나의 항목이 pack 파일뿐인지 보고, 파일 경로(세트 기준)를 낸다.
check_set() {
	(cd "$1" && find . -mindepth 1 -printf '%y %P\n') | sort | while read -r kind path; do
		case "$kind $path" in
		"d m" | "d o") ;;
		"f latest.txt") echo "$path" ;;
		f\ m/*.gpm | f\ o/*.gpk | f\ o/*.gpx)
			[[ $path =~ ^[mo]/[0-9a-f]{64}\.gp[mkx]$ ]] || fail "$1/$path: unexpected object name"
			echo "$path" ;;
		*) fail "$1/$path: unexpected entry ($kind)" ;;
		esac
	done
}

# 2. 허용 Issuer 세트만 옮긴다(수정 시각 유지, s3 sync가 크기·시각으로 비교한다)
stage=$tmp/src
wk=$stage/.well-known/geul
rm -rf "$stage" "$tmp/files.lst" "$tmp/cache"
mkdir -p "$wk"
for i in $issuers; do
	files=$(check_set "$src/$i")
	[ -n "$files" ] || fail "$src/$i: empty set"
	while IFS= read -r f; do
		mkdir -p "$wk/$i/$(dirname "$f")"
		cp -p "$src/$i/$f" "$wk/$i/$f"
	done <<<"$files"
done

# 3. geul로 검사: 객체 해시와 색인, 담긴 Issuer, 문서 수, 규격·버전 검사
"$geul" pack verify "$stage" >&2 || fail "geul pack verify failed"
got=$("$geul" --data "$stage" ls | awk '{print $1}')
[ -n "$got" ] || fail "geul ls: no Issuer"
for g in $got; do
	[ -n "${allow[$(canon "$g")]:-}" ] || fail "$g: Issuer outside ARCHIVE_ISSUERS in the staged sets"
	for d in $deny; do
		[ "$(canon "$g")" != "$(canon "$d")" ] || fail "$g: denied Issuer in the staged sets"
	done
done
for i in $issuers; do
	n=$("$geul" --data "$stage" ls "$i" | wc -l)
	[ "$n" -gt 0 ] || fail "$i: no documents"
	echo "archive-files: $i $n documents" >&2
done
"$geul" --data "$stage" check --archive >&2 || fail "geul check --archive failed"

# 4. 올릴 목록과 상한 검사(geul이 임시 폴더에 무언가 썼다면 여기서 걸린다)
[ "$(ls -A "$wk" | sort | tr '\n' ' ')" = "$(printf '%s\n' $issuers | sort | tr '\n' ' ')" ] ||
	fail "$wk holds more than the Issuer folders: $(ls -A "$wk" | tr '\n' ' ')"
: >"$tmp/files.lst"
for i in $issuers; do
	check_set "$wk/$i" | while IFS= read -r f; do
		printf '%s\t%s\n' "$(stat -c %s "$wk/$i/$f")" "$i/$f"
	done >>"$tmp/files.lst"
done
count=$(wc -l <"$tmp/files.lst")
bytes=$(awk -F'\t' '{s += $1} END {print s + 0}' "$tmp/files.lst")
[ "$count" -gt 0 ] || fail "nothing to upload"
[ "$count" -le "$max_files" ] || fail "$count files > ARCHIVE_MAX_FILES $max_files"
[ "$bytes" -le "$max_bytes" ] || fail "$bytes bytes > ARCHIVE_MAX_BYTES $max_bytes"
echo "archive-files: $count files, $bytes bytes ($issuers) → $tmp/files.lst" >&2
