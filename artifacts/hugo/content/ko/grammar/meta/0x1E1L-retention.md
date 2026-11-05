---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "문서의 보존 기한을 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `RETENTION` (규격 문서 BIND `RETENTION`) |
| TAG ID | `0x1E1L` |
| 코덱 ID | `0x00001E10` |
| 규격 문서 | `0x00000000/codecs/0x00001E10/` (DECLARE 대상 `1E10`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 1 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 보존 기한 |
| Hugo 쪽 | `meta/policy/retention.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | 레코드 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

문서의 보존 기한을 적는다.

## 레이아웃

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length 확장 TAG]
Payload           만료 시각(GREGORIAN-DATE 등) 또는 기간(DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, 정책 클래스
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 등, 또는 [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- 개수: 많아야 하나

## 해석과 유효성

- 기간이면 [RECORDED-AT](0x1D0L-recorded-at.md)부터 센다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E10/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
