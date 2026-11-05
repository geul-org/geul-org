---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT는 언어가 없는 UTF-8 문자열을 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT는 언어가 없는 UTF-8 문자열을 담는 Value다. 짝수·홀수 바이트 코드 쌍 0x072L/0x073L을 쓴다.

| 항목 | 값 |
|---|---|
| 이름 | `UTF8-TEXT` (홀짝 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x072L`·`0x073L` |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 18~19 |
| Kind | Value · 계열: TEXT |
| 색인 설명 | 정규화를 암시하지 않는 valid UTF-8 바이트열. 짝수·홀수 바이트 |
| Hugo 쪽 | `value/text/utf8-text.md` |

## 구성원

이 쪽은 홀짝 쌍 두 코드를 함께 다룬다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수인 값이다([레코드와 TAG WORD](../record.md#가변-길이-바이트열)). 코덱 문서는 코드마다 하나다. 두 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 바이트 수 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | 짝수 | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | 홀수 | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 나머지 날값(`0xFFFF`) |  |  |

UTF8-TEXT는 RFC 3629의 valid UTF-8 바이트열을 담는 Value다. 식별자, 코드, 파일 이름처럼 언어가 없는 문자열에 쓴다.

## 레이아웃

- 코드: Value 직접 코드 `0x072L`(짝수 바이트)·`0x073L`(홀수 바이트). 계열 TEXT.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 3629 문법에 맞는 well-formed shortest-form UTF-8이어야 한다. 디코딩 결과는 `U+0000..U+10FFFF` 범위의 Unicode scalar value만 포함하며, surrogate 범위 `U+D800..U+DFFF`는 포함하지 않는다.
- Payload 선두의 U+FEFF(UTF-8 바이트열 `EF BB BF`)도 다른 위치의 U+FEFF와 같은 문자로 보고 허용한다. RFC 3629가 설명하는 선두 U+FEFF signature(BOM) 처리는 하지 않는다. 떼어 내거나 signature로 해석하지 않고 원문 그대로 보존한다.
- Unicode normalization은 강제하지 않는다. 디코딩한 원문 scalar sequence를 그대로 보존한다.
- 유효한 UTF-8 바이트열을 변환 없이 Payload에 둔다. WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- UTF-8의 scalar 범위와 well-formed 바이트열은 [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)를 따른다.
- 홀짝 코드 쌍, zero padding, GEUL TAG/Length와 16비트 WORD 배치는 이 형식의 canonical framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](../record.md)).
- 0 byte 문자열은 짝수 코드의 1 WORD 레코드(TAG WORD만)로 쓴다([Value](_index.md)).

## 예시

- `A`(`41`)는 1 byte(홀수)라 `UTF8-TEXT-ODD`(`0x073L`), Payload `4100`, 전체 2 WORD, `LLLL=0001`이다. 전체는 `0731 4100`이다.
- 빈 문자열은 `0720`(`UTF8-TEXT-EVEN`, TAG WORD만) 1 WORD다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000720/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

위는 `UTF8-TEXT-EVEN`(`0x072L`)의 코덱 문서다. 다른 구성원(`UTF8-TEXT-ODD`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
