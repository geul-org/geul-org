---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS는 Unix epoch부터의 signed int64 초 수를 담는 Value다(Codec 0x22)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS는 Unix epoch `1970-01-01T00:00:00Z`부터의 signed 초 수다. POSIX의 seconds-since-the-Epoch처럼 모든 날을 정확히 86,400초로 보며 윤초를 세지 않는다.

## 레이아웃

- 코드: Value 직접 코드 `0x22`. 계열 TIME.
- 산업 데이터 교환을 위해 Arrow `timestamp[s]`와 같은 고정폭 signed int64 물리 타입을 쓴다.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  전체 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`초다. 음수는 epoch 이전 instant다.
- 작은 값도 항상 4 WORD를 쓴다. 최소 WORD 정수 표현으로 줄여서는 안 된다.
- timezone, 원래의 UTC offset, 윤초 label, leap-second table은 담지 않는다.

## 길이

- 전체는 TAG 1 WORD와 Payload 4 WORD를 합한 정확히 5 WORD이고 직접 길이 `LLLL=0100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- epoch는 Payload `0000 0000 0000 0000`, 전체 5 WORD, `LLLL=0100`이다.
- epoch 뒤 1초는 Payload `0000 0000 0000 0001`이다.
- epoch 1초 전은 Payload `ffff ffff ffff ffff`이다.

## 표준 근거

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html)은 `time_t tv_sec`와 `long tv_nsec` 멤버를 정의할 뿐, 누적 초를 signed int64로 직렬화하는 wire format은 정의하지 않는다. `time_t`의 구체 폭과 표현은 구현 환경에 따르며 GEUL Payload 표현과 같지 않다.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html)는 epoch 이후 초의 달력 대응과 하루 86,400초 규칙을 정의한다.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)과 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)는 timestamp를 고정 epoch부터의 64비트 signed integer로 정의하고, SECOND 단위와 윤초 비계수를 지원한다. GEUL은 이 물리 타입에 TAG와 big-endian 16비트 WORD framing만 더한다.
