---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL은 signed 32비트 지수 E와 최소 WORD 2의 보수 계수 C로 정확한 10진수 C×10^E를 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL은 부호 있는 coefficient를 가진 정확한 10진수(exact decimal) Value다. Value 직접 코드 `0x10`, 계열 DECIMAL이다. Payload 첫 2 WORD는 signed 32bit 10진 exponent `E`, 나머지는 최소 WORD 2의 보수 coefficient `C`이며 값은 `C×10^E`다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st–2nd (32비트)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 이상)  Signed Two's-complement Coefficient C
```

## 해석

- `E`는 상위 WORD부터 기록한 signed 32bit big-endian 2의 보수 정수다.
- `C`는 나머지 WORD 전체를 상위 WORD부터 이어 붙인 임의 정밀도 2의 보수 정수다.
- `C`는 [SIGNED-INTEGER](/ko/grammar/value/numeric/signed-integer/)와 같은 최소 WORD 규칙을 따른다. 지울 수 있는 선행 `0000` 또는 `ffff` WORD는 금지한다.

## 길이와 유효성

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).
- Payload는 exponent 2 WORD와 coefficient 1 WORD 이상이므로 최소 3 WORD다.
- 바이트 표현의 정규성은 coefficient의 최소 WORD 표현만 검사한다.

## 예시

| 값 표현 | Payload (`E` + `C`) | 판정 |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | 바이트 표현 정규 |
| `10×10^-1` | `ffff ffff 000a` | 바이트 표현 정규, 위 표현과의 canonical 관계는 열린 문제 |
| `1×10^0` | `0000 0000 0000 0001` | 비정규: coefficient 선행 `0000` 불필요 |
| Payload 7 WORD | 직접 길이 `LLLL=0111`, 전체 8 WORD | 정규 길이 구조 |

## 형식 지위

- signed 32비트 exponent `E`와 최소 WORD coefficient `C`를 묶은 이 배치는 IEEE 754 decimal interchange나 Apache Parquet `DECIMAL`이 아닌 GEUL 고유 형식이다.
- Parquet `DECIMAL`은 `unscaledValue × 10^(-scale)`와 필수 precision/scale metadata를 쓰고, byte-array 물리형의 unscaled value를 big-endian 2의 보수로 저장하며 scale은 0 이상이다. 이 형식은 signed `E`를 본문에 넣고 precision metadata가 없으므로 같은 형식이 아니다.
- IEEE 754 decimal이나 Parquet `DECIMAL`과 주고받으려면 범위, precision/scale, quantum, 특수값 정책을 정한 명시적 변환이 필요하다.
- 비교 근거: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 열린 문제

- `10×10^-1`과 `1×10^0`처럼 같은 수를 나타내는 exponent/coefficient 쌍이 여럿 있다.
- 이 형식이 quantum을 보존하는지, 값 동등성을 어떻게 판정하는지, canonical exponent를 어떻게 정규화하는지는 아직 정하지 않았다.
- 그래서 구현은 coefficient 최소 WORD 규칙 밖의 exponent/coefficient 정규화를 임의로 강제해서는 안 된다.
