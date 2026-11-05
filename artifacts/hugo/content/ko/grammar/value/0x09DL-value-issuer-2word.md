---
title: "VALUE-ISSUER-2WORD (0x09DL)"
weight: 157
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-2WORD는 Issuer가 정의한 Value 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-2WORD는 Issuer가 정의한 Value 형식이다. Value 구역의 끝 세 칸 중 하나이고 Issuer 폭이 2 WORD다. 세 Kind의 ISSUER 레이아웃은 같다([레코드와 TAG WORD](../record.md#issuer-형식-레코드)).

| 항목 | 값 |
|---|---|
| 이름 | `VALUE-ISSUER-2WORD` (규격 문서 BIND `VALUE-ISSUER-2WORD`) |
| TAG ID | `0x09DL` |
| 코덱 ID | `0x000009D0` |
| 규격 문서 | `0x00000000/codecs/0x000009D0/` (DECLARE 대상 `09D0`) |
| 섹션 | 4 `0100` (Value), 섹션 안 오프셋 C = 29 |
| Kind | Value · 분류: Issuer 형식 |
| TAG WORD | `0000 1001 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Issuer 2 WORD와 코덱 번호 2 WORD. 형식은 Issuer의 Codec 문서가 정한다 |
| Hugo 쪽 | `value/_index.md` |

## 레이아웃

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 확장 TAG]
Issuer            2 WORD
코덱 번호         2 WORD. Issuer가 정의한다
Payload           Issuer가 발행한 Codec 문서가 정한다
```

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 날값 2 WORD |  |  |
| 2 | `codec` | #3 | 날값 2 WORD |  |  |
| 3 | `payload` | #4 | 나머지 날값(`0xFFFF`) |  |  |

`payload`의 구성은 그 Issuer의 Codec 문서가 정한다.

## 해석과 유효성

- GEUL은 Length로 Payload 경계만 안다. 형식을 모르는 디코더는 Kind, Length, Issuer, 코덱 번호까지 알고 Length로 건너뛴다.
- Payload의 해석은 Issuer의 Codec 문서가 정한다. 지금 등재한 Issuer 형식 Value는 [Codec 색인](../codec-index.md#value-issuer-형식)에 있다.
- Issuer는 값이 들어가는 가장 짧은 폭으로 쓴다([Issuer와 공표](../issuer.md#issuer-등급)). Issuer 2 WORD는 모든 값을 쓸 수 있다.
- 코덱 번호는 2 WORD다. Issuer가 Kind와 상관없이 자기 `codecs/` 안에서 겹치지 않게 배정한다. 번호가 모자라면 Issuer를 하나 더 발급받는다.
- 코덱 문서는 그 Issuer의 `<Issuer>/codecs/<코덱 번호>/` 아래에 둔다([공표 주소와 버전 목록](../publishing.md#id-표기)).
- Issuer 형식의 라이선스는 그 Issuer가 정한다([Issuer와 공표](../issuer.md#라이선스)).

## 관련 페이지

- [Value — Issuer 형식](_index.md#issuer-형식), [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [레코드와 TAG WORD](../record.md#issuer-형식-레코드), [Issuer와 공표](../issuer.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000009D0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009D000000000
BODY
#1 DECLARE 0x09D0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
