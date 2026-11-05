---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST는 SHA3-256 결과 전체를 담는 고정 폭 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST는 SHA3-256 결과 전체를 담는 고정 폭 Value다. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000015` NIST, 코덱 번호 `0x0000C001`, 계열 BINARY다. Payload는 정확히 16 WORD(256 bit)이며 잘라 쓰기(truncation)는 허용하지 않는다.

## 레이아웃

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 확장 TAG   1 WORD  0x0016 (전체 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
코덱 번호         2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## 해석과 유효성

- Payload 32 octet을 SHA3-256 출력 순서 그대로 읽는다. 각 WORD에서는 상위 octet이 먼저 온다.
- digest bit string에 GEUL endian 변환을 따로 적용하지 않는다. 출력 octet sequence를 순서대로 두 octet씩 묶어 16bit big-endian WORD로 framing할 뿐이다.
- Payload가 16 WORD가 아니거나 결과를 임의로 잘라낸 표현은 거부한다. descriptor와 padding은 없다.

## 표준 근거

- SHA3-256 알고리즘과 256bit 결과는 NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final)를 따른다. NIST의 [Hash Functions 프로젝트](https://csrc.nist.gov/Projects/hash-functions)도 SHA-3 표준을 안내한다.
- GEUL TAG, Length, 16bit WORD framing은 이 형식이 더하는 규칙이며 SHA-3 알고리즘의 일부가 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 16 WORD를 합한 정확히 22 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 16 WORD가 아니면 거부한다.

## 예시

- digest octet `d[0]`부터 `d[31]`까지를 16개 Payload WORD에 출력 순서대로 두 octet씩 놓는다. 전체 Length는 항상 22 WORD다.
