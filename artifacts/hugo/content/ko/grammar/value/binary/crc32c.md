---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C는 Castagnoli CRC-32C 결과 32bit를 담는 고정 7 WORD IETF Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C는 CRC-32C 결과를 담는 고정 폭 Value다. Value `VALUE-ISSUER-2WORD`(`0x07DL`), Issuer `0x00000007` IETF, 코덱 번호 `0x0000C000`, 계열 BINARY다. Payload는 정확히 2 WORD(32 bit)다.

## 레이아웃

```
TAG WORD          0x07D6 (0000 0111 1101 0110)  전체 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
코덱 번호         2 WORD  0x0000C000
Payload           2 WORD  CRC32C 상위 16bit │ 하위 16bit
```

## 해석과 유효성

- CRC parameter 표기로 width 32, Castagnoli polynomial `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`다.
- 계산 결과인 unsigned 32bit 정수를 big-endian WORD 순서로 저장한다. 이 직렬화는 RFC 3309의 SCTP Checksum field 배치나 RFC 3720의 iSCSI digest byte mapping 자체가 아니다.
- Payload가 2 WORD가 아니면 거부한다.

## 표준 근거

- CRC-32C 계산과 Castagnoli polynomial·반사 규칙은 [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html)와 [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html)의 CRC32C 정의를 따른다.
- GEUL TAG, Length, 계산된 32bit 정수의 16bit big-endian WORD framing은 이 형식이 더하는 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 2 WORD를 합한 정확히 7 WORD이고 직접 길이 `LLLL=0110`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 2 WORD가 아니면 거부한다.

## 예시

ASCII `123456789`의 CRC-32C check value `0xe3069283`:

```
07D6 0000 0007 0000 C000 e306 9283
```
