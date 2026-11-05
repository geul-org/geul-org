---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "문서 전체의 신뢰도를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `CONFIDENCE` (규격 문서 BIND `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| 코덱 ID | `0x00001E80` |
| 규격 문서 | `0x00000000/codecs/0x00001E80/` (DECLARE 대상 `1E80`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 8 |
| Kind | Meta · 클래스: 검증 |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 신뢰도 |
| Hugo 쪽 | `meta/verification/confidence.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | 레코드 | `0690` UNSIGNED-DECIMAL |  |

문서 전체의 신뢰도를 적는다. 레코드 단위 신뢰도는 대상 Edge에 붙는 QUALIFIER로 쓴다(속성은 미정, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## 레이아웃

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length 확장 TAG]
Payload           UNSIGNED-DECIMAL Value, 0 이상 1 이하
```

- Codec: Meta `0x1E8L`, 검증 클래스
- Payload: 내장 Value([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- 개수: 많아야 하나

## 해석과 유효성

- 누가 매긴 값인지는 [GENERATED-BY](0x1D3L-generated-by.md) 등으로 함께 적는다.

## 열린 문제

- 척도(0~1)와 TOULMIN 판정과의 관계.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E80/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
