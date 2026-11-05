---
title: "MODIFIED-AT (0x1CEL)"
weight: 462
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "문서를 수정한 시각을 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `MODIFIED-AT` (규격 문서 BIND `MODIFIED-AT`) |
| TAG ID | `0x1CEL` |
| 코덱 ID | `0x00001CE0` |
| 규격 문서 | `0x00000000/codecs/0x00001CE0/` (DECLARE 대상 `1CE0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 14 |
| Kind | Meta · 클래스: 출처 |
| TAG WORD | `0001 1100 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 수정 시각. TIME Value |
| Hugo 쪽 | `meta/provenance/modified-at.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 레코드 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

문서를 수정한 시각을 적는다.

## 레이아웃

```
TAG WORD          0001 1100 1110 LLLL      Codec 0x1CEL
[Length 확장 TAG]
Payload           TIME Value 하나 (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 등)
```

- Codec: Meta `0x1CEL`, 출처 클래스
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) 등)
- 개수: 많아야 하나

## 해석과 유효성

- 형식은 TIME 계열 Value 중 고른다. 정밀도가 필요하면 Issuer가 정의한 나노초 형식(예: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md))을 쓴다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001CE0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CE000000000
BODY
#1 DECLARE 0x1CE0
#2 FIELD #1 record
#3 BIND #1 "MODIFIED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
