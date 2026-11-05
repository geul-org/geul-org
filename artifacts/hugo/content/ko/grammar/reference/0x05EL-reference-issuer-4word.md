---
title: "REFERENCE-ISSUER-4WORD (0x05EL)"
weight: 94
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-4WORD는 Issuer가 정의한 Reference 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-4WORD는 Issuer가 정의한 Reference 형식이다. Reference 구역의 끝 세 칸 중 하나이고 Issuer 폭이 4 WORD다. 세 Kind의 ISSUER 레이아웃은 같다([레코드와 TAG WORD](../record.md#issuer-형식-레코드)).

| 항목 | 값 |
|---|---|
| 이름 | `REFERENCE-ISSUER-4WORD` (규격 문서 BIND `REFERENCE-ISSUER-4WORD`) |
| TAG ID | `0x05EL` |
| 코덱 ID | `0x000005E0` |
| 규격 문서 | `0x00000000/codecs/0x000005E0/` (DECLARE 대상 `05E0`) |
| 섹션 | 2 `0010` (Reference 기타), 섹션 안 오프셋 C = 30 |
| Kind | Reference · 분류: Issuer 형식 |
| TAG WORD | `0000 0101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Issuer 4 WORD와 코덱 번호 2 WORD. 형식은 Issuer의 Codec 문서가 정한다 |
| Hugo 쪽 | `reference/reference-issuer.md` |

## 레이아웃

```
TAG WORD          0000 0101 1110 LLLL      Codec 0x05EL
[Length 확장 TAG]
Issuer            4 WORD
코덱 번호         2 WORD. Issuer가 정의한다
Payload           Issuer가 발행한 Codec 문서가 정한다
```

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 날값 4 WORD |  |  |
| 2 | `codec` | #3 | 날값 2 WORD |  |  |
| 3 | `payload` | #4 | 나머지 날값(`0xFFFF`) |  |  |

`payload`의 구성은 그 Issuer의 Codec 문서가 정한다.

## 해석과 유효성

- GEUL은 Length로 Payload 경계만 안다. 형식을 모르는 디코더는 Kind, Length, Issuer, 코덱 번호까지 알고 Length로 건너뛴다.
- 코덱 번호의 뜻, 양화, 무엇을 가리키는지는 Issuer가 발행한 Codec 문서가 정한다. 대상 ID 최단 폭, 양화 읽기 같은 Reference 공통 규칙은 적용되지 않는다([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- Issuer는 값이 들어가는 가장 짧은 폭으로 쓴다([Issuer와 공표](../issuer.md#issuer-등급)). Issuer 값의 상위 2 WORD가 0이면 invalid다. 그 값은 2 WORD 코드([REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md))로 쓴다.
- 코덱 번호는 2 WORD다. Issuer가 Kind와 상관없이 자기 `codecs/` 안에서 겹치지 않게 배정한다. 번호가 모자라면 Issuer를 하나 더 발급받는다.
- 코덱 문서는 그 Issuer의 `<Issuer>/codecs/<코덱 번호>/` 아래에 둔다([공표 주소와 버전 목록](../publishing.md#id-표기)).
- Issuer 형식의 라이선스는 그 Issuer가 정한다([Issuer와 공표](../issuer.md#라이선스)).

## 관련 페이지

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)
- [레코드와 TAG WORD](../record.md#issuer-형식-레코드), [Issuer와 공표](../issuer.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000005E0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005E000000000
BODY
#1 DECLARE 0x05E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
