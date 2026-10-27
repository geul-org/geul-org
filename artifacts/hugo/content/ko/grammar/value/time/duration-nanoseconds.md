---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS는 epoch 없는 signed int64 nanosecond 경과 시간을 담는 Value다(GEUL Issuer 형식 0x4000)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS는 epoch이 없는 signed nanosecond 경과 시간이다. instant나 달력의 월·연 기간이 아니다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0000` GEUL, 형식 번호 `0x4000`. 계열 TIME.
- Arrow `Duration(NANOSECOND)`와 같은 고정폭 signed int64 물리 타입을 쓴다.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  전체 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
형식 번호         1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`ns다. 부호는 경과 방향이며 특정 epoch의 instant를 가리키지 않는다.
- 작은 값도 항상 4 WORD를 쓴다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 4 WORD를 합한 정확히 7 WORD이고 직접 길이 `LLLL=0110`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- 0ns는 Payload `0000 0000 0000 0000`, 전체 7 WORD, `LLLL=0110`이다.
- 1ns는 Payload `0000 0000 0000 0001`이다.
- -1ns는 Payload `ffff ffff ffff ffff`이다.

## 표준 근거

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)은 `Schema.fbs`를 Arrow 표준 데이터 타입의 authoritative source로 지정한다.
- Arrow의 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)에서 `Duration`은 달력과 무관한 절대 경과 시간이며, NANOSECOND 단위를 지원하고 항상 8-byte signed integer로 표현된다. GEUL은 여기에 TAG와 big-endian 16비트 WORD framing만 더한다.
