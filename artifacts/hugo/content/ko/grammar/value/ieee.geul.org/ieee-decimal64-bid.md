---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID는 IEEE 754 decimal64 BID interchange encoding을 나타내는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID는 IEEE 754 decimal64 BID interchange encoding을 나타내는 Value다. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, 코덱 번호 `0x00002004`, 계열 DECIMAL이다. BID 비트 패턴을 그대로 보존하며 DPD와 구별한다.

## 레이아웃

```
TAG WORD          0x09D8  전체 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
코덱 번호         2 WORD  0x00002004
Payload           4 WORD (64비트)  IEEE decimal64 BID Interchange
```

## 해석

- 네 Payload WORD를 상위 WORD부터 이어 붙인 IEEE 754 decimal64 BID interchange 비트열로 읽는다.
- 비트 패턴을 보존하며 DPD 또는 exact decimal 형식으로 임의 재해석하지 않는다.
- 특별값이나 payload를 임의로 정규화하지 않는다.

## 유효성과 길이

- 전체는 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 4 WORD를 합한 정확히 9 WORD이고 직접 길이 `LLLL=1000`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.
- 비트열의 의미상 유효성은 IEEE BID interchange 규칙을 따른다.

## 예시

| 구조 | 판정 |
|---|---|
| `09D8 0000 000D 0000 2004` + 4 WORD BID 비트열 | 정규 길이 구조 |
| `09D8 0000 000D 0000 2004` + 2 WORD | invalid: Payload 폭 불일치 |
| 같은 64비트에 코덱 번호 `0x00002001` | DPD 형식이며 이 타입이 아님 |

## 표준 근거

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): decimal64 interchange format의 binary coefficient encoding(BID)을 적용한다. IEEE가 허용하는 DPD 대안으로 수치 변환하지 않고 선택된 64비트 encoding을 보존하며, GEUL TAG와 WORD big-endian framing만 더한다.
