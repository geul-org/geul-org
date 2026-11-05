---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "이 버전의 시행일을 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `EFFECTIVE-FROM` (규격 문서 BIND `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| 코덱 ID | `0x00001C80` |
| 규격 문서 | `0x00000000/codecs/0x00001C80/` (DECLARE 대상 `1C80`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 8 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 이 버전의 시행일. GREGORIAN-DATE 또는 POSIX-TIMESTAMP Value. 없으면 공표 시각 |
| Hugo 쪽 | `meta/declaration/effective-from.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 레코드 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

이 버전의 시행일을 선언한다. 시행일은 공표 시각과 다르다([개정](../document.md#개정)).

## 레이아웃

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length 확장 TAG]
Payload           TIME Value 하나
```

- Codec: Meta `0x1C8L`, 정의 클래스
- Payload: 내장 Value([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 또는 [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- 개수: 많아야 하나

## 해석과 유효성

- 없으면 공표 시각부터 시행한다.
- [EFFECTIVE-UNTIL](0x1C9L-effective-until.md)이 있으면 그보다 앞서야 한다.
- 조문별로 시행일이 다르면 그 조문 Edge에 QUALIFIER P580(시작)·P582(끝)로 따로 적는다([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- 문서를 특정 시점 기준으로 해석할 때 이 값을 읽는다.

## 예시

- 1970-01-02 시행: `0x1C83 0x06A2 0x0000 0x0001`

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C80/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
