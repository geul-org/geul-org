---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER는 부호 없는 정수 값을 나타내는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `UNSIGNED-INTEGER` (규격 문서 BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| 코덱 ID | `0x00000620` |
| 규격 문서 | `0x00000000/codecs/0x00000620/` (DECLARE 대상 `0620`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 2 |
| Kind | Value · 계열: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 최소 WORD big-endian unsigned magnitude 정수 |
| Hugo 쪽 | `value/numeric/unsigned-integer.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | 나머지 날값(`0xFFFF`) |  |  |

UNSIGNED-INTEGER는 부호 없는 정수 값을 나타내는 Value다. Value 직접 코드 `0x062L`, 계열 NUMERIC이다. Payload 전체를 big-endian WORD 순서의 임의 정밀도 unsigned magnitude로 읽는다. Payload는 최소 1 WORD이며 최소 WORD 정규 표현만 허용한다.

## 레이아웃

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st  (상위 WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (하위 WORD)   Unsigned Magnitude Nth
```

## 해석

- 첫 Payload WORD가 가장 높은 자리, 마지막 WORD가 가장 낮은 자리다.
- Payload가 N WORD이면 `16N` bit unsigned magnitude 하나로 읽는다.
- 이 폭은 선언된 저장 폭이 아니며 bit width descriptor는 없다.

## 정규 표현

- 0은 Payload 1 WORD `0000`이다.
- Payload가 2 WORD 이상일 때 첫 WORD가 `0000`이면 지워도 값이 같으므로 비정규다.
- 디코더는 불필요한 선행 zero WORD가 있는 표현을 거부해야 한다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](../record.md)).
- UINT8·UINT16·UINT32 같은 선언 폭은 보존하지 않고 숫자 값만 보존한다.

## 예시

| 값 | Payload WORD | 판정 |
|---:|---|---|
| 0 | `0000` | 정규 |
| 1 | `0001` | 정규 |
| 65535 | `FFFF` | 정규 |
| 65536 | `0001 0000` | 정규 |
| 1 | `0000 0001` | 비정규: 불필요한 선행 `0000` |
| 7 WORD Payload | TAG `0627`(직접 길이 `LLLL=0111`, 전체 8 WORD) 뒤의 7 WORD | 정규 |
| 7 WORD Payload | 확장 길이 TAG와 확장 값 `0009` 뒤의 7 WORD | 비정규: 14 WORD 이하는 직접 길이로 쓴다 |

## 형식 지위

- 임의 정밀도 unsigned magnitude를 최소 16비트 WORD열로 정규화해 GEUL TAG와 묶는 이 표현은 GEUL 고유 scalar profile이다.
- UINT8/16/32/64 같은 고정 폭 외부 타입과 주고받을 때는 범위 검사와 명시적 폭 변환이 필요하다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000620/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
