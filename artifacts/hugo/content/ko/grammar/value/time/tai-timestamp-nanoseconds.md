---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS는 1970-01-01T00:00:00 TAI부터의 signed nanosecond 수를 담는 Value다(BIPM Issuer 형식 0x4001)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS는 같은 TAI epoch `1970-01-01T00:00:00 TAI`부터의 signed nanosecond 수다. 이 누적 count 표현은 BIPM 표준 wire format이 아니라, TAI 시간척도를 고정폭 signed int64에 매핑한 GEUL 고유 profile이다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0060` BIPM, 형식 번호 `0x4001`. 계열 TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  전체 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
형식 번호         1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`ns다. 음수는 GEUL이 정한 epoch 이전의 TAI instant다.
- 작은 값도 항상 4 WORD를 쓴다. UTC offset이나 leap-second table은 저장하지 않는다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 4 WORD를 합한 정확히 7 WORD이고 직접 길이 `LLLL=0110`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- GEUL TAI epoch는 Payload `0000 0000 0000 0000`, 전체 7 WORD, `LLLL=0110`이다.
- epoch 뒤 1ns는 Payload `0000 0000 0000 0001`이다.
- epoch 1ns 전은 Payload `ffff ffff ffff ffff`이다.

## 표준 근거와 형식 지위

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10)은 SI second와 International Atomic Time(TAI) 시간척도를 규정한다.
- BIPM은 `1970-01-01 TAI` epoch부터의 signed int64 누적 nanosecond나 그 wire encoding을 정의하지 않는다. epoch, 단위별 count, signed int64와 GEUL big-endian WORD 배치는 GEUL 고유 매핑이다.
- 고정폭 int64는 다른 TIME count profile과의 교환 일관성을 위해 고른 것이며, BIPM 형식을 그대로 재현했다는 뜻이 아니다.
