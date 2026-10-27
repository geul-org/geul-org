---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE는 proleptic Gregorian 1970-01-01을 day 0으로 하는 signed int32 날짜 수 Value다(Codec 0x20)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE는 proleptic Gregorian `1970-01-01`을 day 0으로 하는 signed 날짜 수다. 타임존과 하루 중 시각은 담지 않는다.

## 레이아웃

- 코드: Value 직접 코드 `0x20`. 계열 TIME.
- Arrow Date32, Parquet `DATE`와 같은 고정폭 signed int32 물리 타입을 쓴다.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  전체 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## 해석과 유효성

- Payload 2 WORD 전체를 big-endian WORD 순서의 32비트 2의 보수 signed day count로 읽는다.
- 유효 범위는 `-2^31`~`2^31-1`일이다. 음수는 epoch 이전 날짜다.
- day count를 연·월·일로 역산할 때는 역사적 역법 전환 없이 proleptic Gregorian calendar를 쓴다.
- 작은 값도 항상 2 WORD를 쓴다.

## 길이

- 전체는 TAG 1 WORD와 Payload 2 WORD를 합한 정확히 3 WORD이고 직접 길이 `LLLL=0010`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 2 WORD가 아니면 거부한다.

## 예시

| 날짜 | Payload | 전체 Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## EDTF와의 관계

- 날보다 거친 정밀도, 불확실·대략, 구간은 [EDTF](/ko/grammar/value/time/edtf/)로 쓴다. GREGORIAN-DATE로 정확히 쓸 수 있는 날짜는 EDTF로 쓰지 않는다(EDTF 정규형).

## 표준 근거

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/)의 `DATE`는 Unix epoch인 1970-01-01부터의 일수를 저장하는 `int32`이며 signed 순서를 쓴다.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)과 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)의 Date32는 Unix epoch부터의 일수를 32비트 signed integer로 저장한다.
- proleptic Gregorian 역산은 이 형식이 채택한 GEUL calendar profile이다. Arrow/Parquet의 int32 day-count 의미는 그대로 두고 TAG와 big-endian 16비트 WORD framing만 더한다.
