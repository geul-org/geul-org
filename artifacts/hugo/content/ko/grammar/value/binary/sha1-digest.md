---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST는 SHA-1 결과 160bit 전체를 담는 고정 11 WORD Value로, git 객체 ID 같은 식별 용도로만 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST는 SHA-1 결과 전체를 담는 고정 폭 Value다. Value 직접 코드 `0x62`, 계열 BINARY다. Payload는 정확히 10 WORD(160 bit)이며 잘라 쓰기(truncation)는 허용하지 않는다.

**식별 용도로만 쓴다.** SHA-1은 충돌 저항이 깨졌다(2017 SHAttered). 무결성·서명의 근거로는 [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/)를 쓴다. 이 형식은 이미 SHA-1로 정해진 식별자, 대표적으로 SHA-1 git 저장소의 객체 ID(커밋 ID)를 그대로 담으려고 둔다. 예를 들어 [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/)의 Version(커밋 ID)을 hex 텍스트(22 WORD) 대신 11 WORD로 담는다.

## 레이아웃

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
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
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 관련 페이지

- [Value](/ko/grammar/value/), [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/)
