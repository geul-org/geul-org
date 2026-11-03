---
title: "IEEE-DECIMAL128-DPD"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD는 IEEE 754 decimal128 DPD interchange 비트열을 그대로 담는 고정 13 WORD Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD는 IEEE 754 decimal128 DPD interchange encoding을 나타내는 Value다. Value `VALUE-ISSUER-2WORD`(`0x07DL`), Issuer `0x0000000D` IEEE, 코덱 번호 `0x00002002`, 계열 DECIMAL이다. DPD 비트 패턴을 그대로 보존하며 BID와 구별한다.

## 레이아웃

```
TAG WORD          0x07DC  전체 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
코덱 번호         2 WORD  0x00002002
Payload           8 WORD (128비트)  IEEE decimal128 DPD Interchange
```

## 해석

- 여덟 Payload WORD를 상위 WORD부터 이어 붙인 IEEE 754 decimal128 DPD interchange 비트열로 읽는다.
- 비트 패턴을 보존하며 BID 또는 exact decimal 형식으로 임의 재해석하지 않는다.
- 특별값이나 payload를 임의로 정규화하지 않는다.

## 유효성과 길이

- 전체는 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 8 WORD를 합한 정확히 13 WORD이고 직접 길이 `LLLL=1100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.
- 비트열의 의미상 유효성은 IEEE DPD interchange 규칙을 따른다.

## 예시

| 구조 | 판정 |
|---|---|
| `07DC 0000 000D 0000 2002` + 8 WORD DPD 비트열 | 정규 |
| 전체가 13 WORD(`LLLL=1100`)가 아님 | invalid: 고정 Payload 폭과 불일치 |

## 표준 근거

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): decimal128 interchange format의 decimal coefficient encoding(DPD)을 적용한다. IEEE가 허용하는 BID 대안으로 수치 변환하지 않고 선택된 128비트 encoding을 보존하며, GEUL TAG와 WORD big-endian framing만 더한다.
