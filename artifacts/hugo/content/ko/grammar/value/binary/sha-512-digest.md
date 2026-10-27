---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST는 SHA-512 결과 512bit 전체를 담는 고정 36 WORD NIST Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST는 SHA-2 계열 SHA-512의 결과 전체를 담는 고정 폭 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0062` NIST, 형식 번호 `0xC000`, 계열 BINARY다. Payload는 정확히 32 WORD(512 bit)이며 잘라 쓰기(truncation)는 허용하지 않는다.

## 레이아웃

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 확장 TAG   1 WORD  0x0024 (전체 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
형식 번호         1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## 해석과 유효성

- Payload 64 octet을 SHA-512 출력 순서 그대로 읽는다. 각 WORD에서는 상위 octet이 먼저 온다.
- digest bit string에 GEUL endian 변환을 따로 적용하지 않는다. 출력 octet sequence를 순서대로 두 octet씩 묶어 16bit big-endian WORD로 framing할 뿐이다.
- Payload가 32 WORD가 아니거나 결과를 임의로 잘라낸 표현은 거부한다. descriptor와 padding은 없다.

## 표준 근거

- SHA-512 알고리즘과 512bit 결과는 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)를 따른다.
- GEUL TAG, Length, 16bit WORD framing은 이 형식이 더하는 규칙이며 SHA-2 알고리즘의 일부가 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 32 WORD를 합한 정확히 36 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 32 WORD가 아니면 거부한다.

## 예시

- digest octet `d[0]`부터 `d[63]`까지는 Payload WORD `(d[0]<<8)|d[1]`부터 `(d[62]<<8)|d[63]`까지 순서대로 놓는다. 전체 Length는 항상 36 WORD다.
