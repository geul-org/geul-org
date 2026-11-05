---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE는 proleptic Gregorian 1970-01-01을 day 0으로 하는 signed 날짜 수다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `GREGORIAN-DATE` (규격 문서 BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| 코덱 ID | `0x000006A0` |
| 규격 문서 | `0x00000000/codecs/0x000006A0/` (DECLARE 대상 `06A0`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 10 |
| Kind | Value · 계열: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | proleptic Gregorian `1970-01-01` 기준 signed 날짜 수 |
| Hugo 쪽 | `value/time/gregorian-date.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | 날값 2 WORD |  |  |

GREGORIAN-DATE는 proleptic Gregorian `1970-01-01`을 day 0으로 하는 signed 날짜 수다. 타임존과 하루 중 시각은 담지 않는다.

## 레이아웃

- 코드: Value 직접 코드 `0x06AL`. 계열 TIME.
- Arrow Date32, Parquet `DATE`와 같은 고정폭 signed int32 물리 타입을 쓴다.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  전체 3 WORD
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
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## EDTF와의 관계

- 날보다 거친 정밀도, 불확실·대략, 구간은 [EDTF](0x06EL-edtf.md)로 쓴다. GREGORIAN-DATE로 정확히 쓸 수 있는 날짜는 EDTF로 쓰지 않는다(EDTF 정규형).

## 표준 근거

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/)의 `DATE`는 Unix epoch인 1970-01-01부터의 일수를 저장하는 `int32`이며 signed 순서를 쓴다.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)과 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)의 Date32는 Unix epoch부터의 일수를 32비트 signed integer로 저장한다.
- proleptic Gregorian 역산은 이 형식이 채택한 GEUL calendar profile이다. Arrow/Parquet의 int32 day-count 의미는 그대로 두고 TAG와 big-endian 16비트 WORD framing만 더한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000006A0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
