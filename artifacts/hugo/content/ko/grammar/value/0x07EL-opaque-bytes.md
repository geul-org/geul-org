---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES는 의미와 형식을 이 형식 자체에서 정하지 않는 임의의 바이트열이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES는 의미와 형식을 이 형식 자체에서 정하지 않는 임의의 바이트열이다. Value 직접 코드 `0x07EL`(짝수 바이트)·`0x07FL`(홀수 바이트), 계열 BINARY다. 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](_index.md)).

| 항목 | 값 |
|---|---|
| 이름 | `OPAQUE-BYTES` (홀짝 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x07EL`·`0x07FL` |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 30~31 |
| Kind | Value · 계열: BINARY |
| 색인 설명 | 의미·형식 불명의 바이트열. 짝수·홀수 바이트 |
| Hugo 쪽 | `value/binary/opaque-bytes.md` |

## 구성원

이 쪽은 홀짝 쌍 두 코드를 함께 다룬다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수인 값이다([레코드와 TAG WORD](../record.md#가변-길이-바이트열)). 코덱 문서는 코드마다 하나다. 두 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 바이트 수 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | 짝수 | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | 홀수 | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 나머지 날값(`0xFFFF`) |  |  |

## 레이아웃

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth   바이트 / 마지막 zero padding
```

## 해석과 유효성

- Payload에서 바이트 수만큼 byte를 순서대로 읽는다. WORD 안에서는 상위 byte가 먼저 온다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.
- 짝수·홀수 코드, Payload WORD 수, zero padding이 서로 맞지 않으면 거부한다.

## 형식 지위

- 홀짝 코드 쌍(`0x07EL` 짝수, `0x07FL` 홀수), payload 배치, 마지막 WORD zero padding은 외부 산업표준을 인용한 것이 아니라 GEUL 고유 framing이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](../record.md)).
- 0 byte는 짝수 코드(`0x07EL`)의 1 WORD 레코드(TAG WORD만)로 쓴다([Value](_index.md)).

## 예시

byte `AB CD EF`는 3 byte(홀수)라 `OPAQUE-BYTES-ODD`(`0x07FL`), Payload `ABCD EF00`이다. 전체 3 WORD이므로 `LLLL=0010`이다.

```
07F2 ABCD EF00
```

빈 바이트열은 `07E0`(`OPAQUE-BYTES-EVEN`, TAG WORD만) 1 WORD다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000007E0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

위는 `OPAQUE-BYTES-EVEN`(`0x07EL`)의 코덱 문서다. 다른 구성원(`OPAQUE-BYTES-ODD`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
