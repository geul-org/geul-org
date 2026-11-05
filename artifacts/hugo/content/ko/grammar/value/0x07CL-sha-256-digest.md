---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST는 SHA-2 계열 SHA-256의 결과 전체를 담는 고정 폭 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SHA-256-DIGEST` (규격 문서 BIND `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| 코덱 ID | `0x000007C0` |
| 규격 문서 | `0x00000000/codecs/0x000007C0/` (DECLARE 대상 `07C0`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 28 |
| Kind | Value · 계열: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 고정 Payload 16 WORD의 SHA-256 결과 |
| Hugo 쪽 | `value/binary/sha-256-digest.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 날값 16 WORD |  |  |

SHA-256-DIGEST는 SHA-2 계열 SHA-256의 결과 전체를 담는 고정 폭 Value다. Value 직접 코드 `0x07CL`, 계열 BINARY다. Payload는 정확히 16 WORD(256 bit)이며 잘라 쓰기(truncation)는 허용하지 않는다.

## 레이아웃

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length 확장 TAG   1 WORD  0x0012 (전체 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## 해석과 유효성

- Payload 32 octet을 SHA-256 출력 순서 그대로 읽는다. 각 WORD에서는 상위 octet이 먼저 온다.
- digest bit string에 GEUL endian 변환을 따로 적용하지 않는다. 출력 octet sequence를 순서대로 두 octet씩 묶어 16bit big-endian WORD로 framing할 뿐이다.
- Payload가 16 WORD가 아니거나 결과를 임의로 잘라낸 표현은 거부한다. descriptor와 padding은 없다.

## 표준 근거

- SHA-256 알고리즘과 256bit 결과는 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)를 따른다.
- GEUL TAG, Length, 16bit WORD framing은 이 형식이 더하는 규칙이며 SHA-2 알고리즘의 일부가 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Payload 16 WORD를 합한 정확히 18 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 16 WORD가 아니면 거부한다.

## 예시

- digest octet `d[0]`부터 `d[31]`까지는 Payload WORD `(d[0]<<8)|d[1]`부터 `(d[30]<<8)|d[31]`까지 순서대로 놓는다. 전체 Length는 항상 18 WORD다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000007C0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
