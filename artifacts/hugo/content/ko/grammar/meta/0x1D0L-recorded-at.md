---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "문서로 기록한 시각을 적는다(git commit date)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `RECORDED-AT` (규격 문서 BIND `RECORDED-AT`) |
| TAG ID | `0x1D0L` |
| 코덱 ID | `0x00001D00` |
| 규격 문서 | `0x00000000/codecs/0x00001D00/` (DECLARE 대상 `1D00`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 16 |
| Kind | Meta · 클래스: 출처 |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 기록한 시각. TIME Value (git commit date) |
| Hugo 쪽 | `meta/provenance/recorded-at.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 레코드 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

문서로 기록한 시각을 적는다(git commit date).

## 레이아웃

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[Length 확장 TAG]
Payload           TIME Value 하나 (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 등)
```

- Codec: Meta `0x1D0L`, 출처 클래스
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) 등)
- 개수: 많아야 하나

## 해석과 유효성

- 형식은 TIME 계열 Value 중 고른다. 정밀도가 필요하면 Issuer가 정의한 나노초 형식(예: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md))을 쓴다.
- 버전 목록 문서([PUBLICATION](../edge/0x0B8L-publication.md))는 이 값을 공표·폐기(deprecate)·삭제 시각으로 쓴다.

## 열린 문제

- 출처 Meta는 내용 해시에 들어간다. 같은 내용을 다른 시각에 기록하면 해시가 달라지는 것을 허용할지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D00/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
