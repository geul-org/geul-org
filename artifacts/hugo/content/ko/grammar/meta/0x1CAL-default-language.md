---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "문서 텍스트의 기본 언어를 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DEFAULT-LANGUAGE` (규격 문서 BIND `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| 코덱 ID | `0x00001CA0` |
| 규격 문서 | `0x00000000/codecs/0x00001CA0/` (DECLARE 대상 `1CA0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 10 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 기본 언어 |
| Hugo 쪽 | `meta/declaration/default-language.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | 레코드 | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

문서 텍스트의 기본 언어를 선언한다. 언어를 따로 적지 않은 텍스트는 이 언어다.

## 레이아웃

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length 확장 TAG]
Payload           언어 Value 하나
```

- Codec: Meta `0x1CAL`, 정의 클래스
- Payload: 내장 Value([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) 또는 [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- 개수: 많아야 하나

## 해석과 유효성

- TANGEUL 문서는 작성 로케일을 적는다(예: `en`, `ko`).

## 예시

- `en`: `0x1CA2 0x0761 0x656E`

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001CA0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
