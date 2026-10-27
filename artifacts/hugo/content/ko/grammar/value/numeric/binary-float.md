---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT은 IEEE 754 binary16/32/64/128 interchange 비트열을 그대로 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT은 IEEE 754 binary interchange scalar를 나타내는 Value다. Value 직접 코드 `0x03`, 계열 NUMERIC이다. Payload가 1/2/4/8 WORD이면 각각 binary16/32/64/128이다. interchange 비트열을 그대로 보존하며 다른 Payload 크기는 허용하지 않는다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st  (상위 WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (하위 WORD)   IEEE Binary Interchange Nth
```

## 해석

- Payload WORD를 big-endian 순서로 이어 붙여 해당 폭의 IEEE 754 binary interchange 비트열로 읽는다.
- NaN payload와 signed zero를 포함한 interchange 비트 패턴을 보존한다.
- 디코더는 NaN을 임의의 정규 NaN 하나로 바꾸거나 signed zero의 부호를 지워서는 안 된다.
- 반올림 방식과 산술 동작은 이 직렬화 형식이 정하지 않는다.

## 길이

전체는 TAG 1 WORD, Length 확장 TAG(있으면), Payload를 합한 WORD 수다([레코드와 TAG WORD](/ko/grammar/record/)).

| 형식 | Payload | Length 코드 | Length 확장 TAG | 전체 Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | 없음 | 2 WORD |
| binary32 | 2 WORD | `0010` | 없음 | 3 WORD |
| binary64 | 4 WORD | `0100` | 없음 | 5 WORD |
| binary128 | 8 WORD | `1000` | 없음 | 9 WORD |

binary128도 1~14 WORD 직접 범위에 있으므로 Length 확장 TAG를 쓰지 않는다.

## 유효성

- Payload는 정확히 1, 2, 4, 8 WORD 중 하나다.
- 각 Payload 크기는 위 표의 Length 표현과 정확히 맞아야 한다.
- 폭을 바꾸는 재인코딩이나 Payload 앞뒤의 padding WORD는 허용하지 않는다.

## 예시

| 형식 | TAG | Length 확장 TAG | Payload 예 | 판정 |
|---|---|---|---|---|
| binary16 | `0883` | 없음 | `0000` | 정규 |
| binary32 | `0903` | 없음 | `0000 0000` | 정규 |
| binary64 | `0A03` | 없음 | `0000 0000 0000 0000` | 정규 |
| binary128 | `0C03` | 없음 | 8 WORD 비트열 | 정규 |
| 임의 | Length가 나타내는 크기와 불일치 | 임의 | 임의 | invalid |

## 표준 근거

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): binary16, binary32, binary64, binary128 interchange encoding을 적용한다. GEUL은 그 비트열에 TAG와 16비트 WORD big-endian framing만 더한다.
