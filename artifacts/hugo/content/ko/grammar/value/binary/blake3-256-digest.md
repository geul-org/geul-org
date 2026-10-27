---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST는 BLAKE3 기본 hash mode 출력의 첫 32 octet을 담는 고정 20 WORD Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST는 BLAKE3 default hash mode 출력의 첫 32 octet(256 bit)을 담는 고정 폭 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0xC000`, 계열 BINARY다. Payload는 정확히 16 WORD이며 keyed hash mode, key derivation mode, 다른 길이의 XOF 출력은 담지 않는다.

## 레이아웃

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 확장 TAG   1 WORD  0x0014 (전체 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## 해석과 유효성

- Payload는 BLAKE3 default hash mode output stream의 첫 32 octet이다. 출력 순서를 보존하고 각 WORD에서는 상위 octet이 먼저 온다.
- 출력에 GEUL endian 변환을 따로 적용하지 않는다. 출력 octet sequence를 순서대로 두 octet씩 묶어 16bit big-endian WORD로 framing한다.
- Payload가 16 WORD가 아니거나 keyed_hash, derive_key, 다른 길이의 XOF 결과를 담은 표현은 거부한다. descriptor와 padding은 없다.

## 표준 근거

- 알고리즘과 mode·output 정의는 BLAKE3 팀의 [공식 구현 저장소](https://github.com/BLAKE3-team/BLAKE3)와 [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf)을 따른다.
- GEUL TAG, Length, 16bit WORD framing은 이 형식이 더하는 규칙이며 BLAKE3 알고리즘의 일부가 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 16 WORD를 합한 정확히 20 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 16 WORD가 아니면 거부한다.

## 예시

- output octet `d[0]`부터 `d[31]`까지를 16개 Payload WORD에 출력 순서대로 두 octet씩 놓는다. 전체 Length는 항상 20 WORD다.
