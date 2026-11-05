---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR는 길이를 밝힌 raw bit sequence다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR는 길이를 밝힌 raw bit sequence다. Value 직접 코드 `0x080L`, 계열 BINARY다. 첫 2 Payload WORD는 unsigned 32bit bit count `N`이고, 뒤에 `ceil(N/16)` WORD가 온다.

| 항목 | 값 |
|---|---|
| 이름 | `BIT-VECTOR` (규격 문서 BIND `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| 코덱 ID | `0x00000800` |
| 규격 문서 | `0x00000000/codecs/0x00000800/` (DECLARE 대상 `0800`) |
| 섹션 | 4 `0100` (Value), 섹션 안 오프셋 C = 0 |
| Kind | Value · 계열: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | bit-count 뒤에 MSB-first로 저장한 N bit |
| Hugo 쪽 | `value/binary/bit-vector.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | 날값 2 WORD |  |  |
| 2 | `bits` | #3 | 나머지 날값(`0xFFFF`) |  |  |

## 레이아웃

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st–2nd       Bit Count N (상위 16bit │ 하위 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 해석과 유효성

- `N`은 첫 2 Payload WORD를 big-endian unsigned 32bit 정수로 읽은 값이다.
- payload bit는 각 WORD의 최상위 비트부터 차례로 채운다.
- payload WORD 수는 정확히 `ceil(N/16)`이고 마지막 WORD에서 쓰지 않는 하위 bit는 모두 0이어야 한다.
- `N=0`이면 payload WORD는 없다. 두 count WORD가 이미 Payload를 이루므로 Payload 최소 1 WORD 규칙과 충돌하지 않는다.

## 형식 지위

- unsigned 32bit bit count, MSB-first 배치, 마지막 WORD zero padding은 외부 산업표준을 인용한 것이 아니라 GEUL 고유 framing이다.
- GEUL TAG, Length, 16bit WORD 규칙을 포함해 이 페이지가 표현을 정의한다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](../record.md)).

## 예시

- 빈 bit vector는 count `0000 0000`, payload 없음, 전체 3 WORD, `LLLL=0010`이다. 전체는 `0802 0000 0000`이다.
- bit sequence `101`은 count `0000 0003`, payload `A000`, 전체 4 WORD, `LLLL=0011`이다. 전체는 `0803 0000 0003 A000`이다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000800/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
