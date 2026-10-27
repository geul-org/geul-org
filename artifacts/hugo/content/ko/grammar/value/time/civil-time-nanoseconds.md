---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS는 날짜 없는 민사시각을 자정 후 nanosecond 수로 담는 Value다(Codec 0x21)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS는 날짜 없는 민사시각을 자정 후 nanosecond 수로 나타낸다.

## 레이아웃

- 코드: Value 직접 코드 `0x21`. 계열 TIME.
- Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`와 같은 고정폭 signed int64 물리 타입을 쓴다.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  전체 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 물리 타입은 signed int64지만 유효 범위는 `0 <= value < 86,400×10^9`ns다. 음수와 상한 이상은 거부한다.
- `24:00`과 윤초 label은 허용하지 않는다. 날짜, 타임존, UTC offset도 담지 않는다.
- 작은 값도 항상 4 WORD를 쓴다.

## 길이

- 전체는 TAG 1 WORD와 Payload 4 WORD를 합한 정확히 5 WORD이고 직접 길이 `LLLL=0100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- 자정은 Payload `0000 0000 0000 0000`, 전체 5 WORD, `LLLL=0100`이다.
- 자정 후 1ns는 Payload `0000 0000 0000 0001`이다.
- `86,400×10^9`ns는 상한과 같으므로 유효하지 않다.
- `ffff ffff ffff ffff`는 signed int64로 -1이므로 유효하지 않다.

## 표준 근거

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/)의 `TIME(isAdjustedToUTC=false, unit=NANOS)`는 local time의 자정 후 nanosecond를 `int64`에 저장하며 signed 순서를 쓴다.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)의 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)는 NANOSECOND Time을 64비트 signed integer로 정의하고, 유효 범위를 자정 포함 86,400초 미만으로 제한하며 윤초를 허용하지 않는다. GEUL은 TAG와 big-endian 16비트 WORD framing만 더한다.
