---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS는 Unix epoch부터의 signed int64 nanosecond 수를 담는 Value다(IEEE Issuer 형식 0x4000)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS는 Unix epoch `1970-01-01T00:00:00Z`부터의 signed nanosecond 수다. POSIX의 seconds-since-the-Epoch처럼 모든 날을 정확히 86,400초로 보며 윤초를 세지 않는다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0040` IEEE, 형식 번호 `0x4000`. 계열 TIME.
- 산업 데이터 교환을 위해 Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`와 같은 고정폭 signed int64 물리 타입을 쓴다.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  전체 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
형식 번호         1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`ns이며, instant 범위는 `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`다.
- 작은 값도 항상 4 WORD를 쓴다. 최소 WORD 정수 표현으로 줄여서는 안 된다.
- timezone, 원래의 UTC offset, 윤초 label, leap-second table은 담지 않는다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 4 WORD를 합한 정확히 7 WORD이고 직접 길이 `LLLL=0110`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- epoch는 Payload `0000 0000 0000 0000`, 전체 7 WORD, `LLLL=0110`이다.
- epoch 뒤 1ns는 Payload `0000 0000 0000 0001`이다.
- epoch 1ns 전은 Payload `ffff ffff ffff ffff`이다.

## 표준 근거

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html)은 `time_t tv_sec`와 `long tv_nsec` 멤버, `0 <= tv_nsec < 10^9`를 정의한다. `time_t`의 구체 폭과 표현은 구현 환경에 따르며, 두 멤버를 합친 누적 nanosecond signed int64 wire format은 정의하지 않는다.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html)는 하루를 정확히 86,400초로 본다.
- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/)의 `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`는 Unix epoch부터의 nanosecond를 단일 `int64`로 저장한다. GEUL은 이 물리 타입에 TAG와 big-endian 16비트 WORD framing만 더한다.
