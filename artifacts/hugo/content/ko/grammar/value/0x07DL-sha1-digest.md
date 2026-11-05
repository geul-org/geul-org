---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST는 SHA-1 결과 전체를 담는 고정 폭 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SHA1-DIGEST` (규격 문서 BIND `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| 코덱 ID | `0x000007D0` |
| 규격 문서 | `0x00000000/codecs/0x000007D0/` (DECLARE 대상 `07D0`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 29 |
| Kind | Value · 계열: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 고정 Payload 10 WORD의 SHA-1 결과. git 객체 ID 같은 식별 용도로만 |
| Hugo 쪽 | `value/binary/sha1-digest.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 날값 10 WORD |  |  |

SHA1-DIGEST는 SHA-1 결과 전체를 담는 고정 폭 Value다. Value 직접 코드 `0x07DL`, 계열 BINARY다. Payload는 정확히 10 WORD(160 bit)이며 잘라 쓰기(truncation)는 허용하지 않는다.

**식별 용도로만 쓴다.** SHA-1은 충돌 저항이 깨졌다(2017 SHAttered). 무결성·서명의 근거로는 [SHA-256-DIGEST](0x07CL-sha-256-digest.md)를 쓴다. 이 형식은 이미 SHA-1로 정해진 식별자, 대표적으로 SHA-1 git 저장소의 객체 ID(커밋 ID)를 그대로 담으려고 둔다. 예를 들어 [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)의 Version(커밋 ID)을 hex 텍스트(22 WORD) 대신 11 WORD로 담는다.

## 레이아웃

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## 해석과 유효성

- Payload 20 octet을 SHA-1 출력 순서 그대로 읽는다. 각 WORD에서는 상위 octet이 먼저 온다(SHA-256-DIGEST와 같은 framing).
- Payload가 10 WORD가 아니거나 결과를 임의로 잘라낸 표현(git 축약 ID 등)은 거부한다. descriptor와 padding은 없다.
- git 객체 ID는 git이 계산한 값 그대로다. git의 SHA-1은 충돌 탐지를 넣은 변형(SHA-1DC)이지만, 충돌 공격이 아닌 입력에서는 결과가 SHA-1과 같다.

## 표준 근거

- SHA-1 알고리즘과 160bit 결과는 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)를 따른다.
- GEUL TAG와 16bit WORD framing은 이 형식이 더하는 규칙이다.

## 길이

- 전체는 TAG 1 WORD와 Payload 10 WORD를 합한 정확히 11 WORD이고 `LLLL=1010`을 쓴다. Length 확장은 없다.

## 예시

git 커밋 `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 관련 페이지

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000007D0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
