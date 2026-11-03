---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64는 binary64 하한·상한으로 유한하고 비어 있지 않은 닫힌 구간을 담는 고정 13 WORD ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64는 `(lower, upper)` 순서의 IEEE 754 binary64 두 endpoint로 닫힌 구간을 나타내는 Value다. Value `VALUE-ISSUER-2WORD`(`0x07DL`), Issuer `0x00000002` ADHOC, 코덱 번호 `0x00000703`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0x07DC (0000 0111 1101 1100)  전체 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
코덱 번호         2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## 해석과 유효성

- 두 endpoint는 big-endian WORD 순서의 binary64이며 양 끝을 포함한다.
- 유효한 endpoint의 signed zero bit pattern은 그대로 보존한다. ABI padding은 없다.
- Payload는 정확히 8 WORD이고 `lower ≤ upper`여야 한다.
- NaN은 비교할 수 없으므로 거부한다. infinity endpoint도 unbounded 구간이므로 거부한다.
- empty, unbounded, open interval과 NaI는 이 형식으로 표현할 수 없으며 거부한다.

## 표준 근거와 형식 지위

- endpoint 수치 형식은 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)를 따르며, 닫힌 endpoint pair라는 뜻은 [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/)과 simplified flavor인 [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734)의 interval 모델을 참고한다.
- 이 형식은 유한하고 비어 있지 않은 닫힌 구간만 허용하는 단순 GEUL profile이다. decorations, NaI, empty/unbounded interval, IEEE 1788/1788.1의 전체 연산·interchange 모델을 구현하거나 그대로 직렬화하지 않는다.

## 길이

- 전체는 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 8 WORD를 합한 정확히 13 WORD이고 직접 길이 `LLLL=1100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

- endpoint `(1.0, 2.0)`은 `[1.0, 2.0]`이고 유효하다. `(2.0, 1.0)`과 `(NaN, 1.0)`은 invalid다.
