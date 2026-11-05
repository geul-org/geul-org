---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "문서가 따르는 GEUL 명세 판을 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SPEC-VERSION` (규격 문서 BIND `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| 코덱 ID | `0x00001C50` |
| 규격 문서 | `0x00000000/codecs/0x00001C50/` (DECLARE 대상 `1C50`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 5 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 따르는 GEUL 명세 판. Payload가 곧 가장 짧은 폭의 unsigned 정수다. v1은 `0x0001` (레코드 `0x1C51 0x0001`) |
| Hugo 쪽 | `meta/declaration/spec-version.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 나머지 날값(`0xFFFF`) |  |  |

문서가 따르는 GEUL 명세 판을 선언한다. 나머지 레코드를 어떻게 읽을지 이 값이 정한다.

## 레이아웃

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length 확장 TAG]
Payload           명세 판. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, 정의 클래스
- Payload: 날값(가장 짧은 폭의 unsigned 정수)
- 개수: 많아야 하나

## 해석과 유효성

- Value 코드에 기대지 않는다. 어느 판의 디코더든 읽을 수 있게 내장 Value 없이 정수만 둔다.
- 모르는 판이면 디코더는 거부하거나 경고한다.
- 없으면 디코더가 아는 판으로 읽는다. 공표 문서는 적는다.

## 예시

- `0x1C51 0x0001`: GEUL v1

## 열린 문제

- 코덱북 문서 버전과의 대응([규격 문서](../codec-spec.md)).

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C50/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
