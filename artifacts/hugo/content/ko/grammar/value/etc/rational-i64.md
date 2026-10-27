---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64는 int64 분자와 양의 int64 분모의 기약분수로 유리수를 담는 고정 11 WORD ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64는 big-endian int64 numerator와 int64 denominator의 기약분수로 유리수를 나타내는 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0702`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  전체 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## 해석과 유효성

- 각 int64는 상위 WORD부터 이어 붙인 고정 폭 2의 보수 정수이며 값은 `numerator / denominator`다.
- ABI padding은 없다.
- Payload는 정확히 8 WORD이고 denominator는 양수여야 한다.
- `gcd(|numerator|, denominator) = 1`인 기약형만 허용한다. 0은 오직 `0/1`로 쓴다.

## 형식 지위

- 두 int64, 양수 denominator, 최대공약수 1, `0/1` canonicalization은 외부 wire 표준을 채택한 것이 아니라 GEUL 고유 형식이다.
- 각 int64의 2의 보수 해석, 성분 순서, big-endian WORD framing을 포함해 이 페이지가 표현을 완전히 정의한다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 8 WORD를 합한 정확히 11 WORD이고 직접 길이 `LLLL=1010`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

- numerator `1`, denominator `2`는 유효한 `1/2`다. `2/4`, `0/2`, denominator `-2`는 invalid다.
