---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER는 부호 있는 정수를 최소 WORD 2의 보수로 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER는 부호 있는 정수 값을 나타내는 Value다. Value 직접 코드 `0x01`, 계열 NUMERIC이다. Payload 전체를 big-endian WORD 순서의 임의 정밀도 2의 보수 정수로 읽는다. Payload는 최소 1 WORD이며 최소 WORD 정규 표현만 허용한다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st  (상위 WORD)   Integer 1st
...
Payload WORD Nth  (하위 WORD)   Integer Nth
```

## 해석

- 첫 Payload WORD의 최상위 비트가 정수 전체의 부호 비트다.
- 모든 Payload WORD를 하나의 연속된 2의 보수 비트열로 읽는다. 첫 WORD가 가장 높은 자리, 마지막 WORD가 가장 낮은 자리다.
- Payload가 N WORD이면 해석 폭은 `16N` bit다. 이 폭은 선언된 저장 폭이 아니라 정규 표현에서 정해지는 값의 표현 폭이다.
- Byte Count나 bit width descriptor는 없다.

## 정규 표현

- 0은 Payload 1 WORD `0000`이다.
- 값을 바꾸지 않는 선행 부호 확장 WORD는 금지한다.
- Payload가 2 WORD 이상일 때 다음은 비정규다.
  - 첫 WORD가 `0000`이고 다음 WORD의 최상위 비트가 0
  - 첫 WORD가 `ffff`이고 다음 WORD의 최상위 비트가 1
- 양수의 부호를 지키는 선행 `0000`은 다음 WORD의 최상위 비트가 1일 때 허용한다.
- 음수의 부호를 지키는 선행 `ffff`는 다음 WORD의 최상위 비트가 0일 때 허용한다.
- 디코더는 비정규 표현을 거부해야 한다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).
- INT8·INT16·INT32 같은 선언 폭은 보존하지 않고 숫자 값만 보존한다. `-32768`~`32767`은 1 WORD이고, 범위를 벗어나면 필요한 만큼 WORD를 더한다. 별도의 SIGNED-INT8 형식은 없다.

## 예시

| 값 | Payload WORD | 판정 |
|---:|---|---|
| 0 | `0000` | 정규 |
| 1 | `0001` | 정규 |
| 32767 | `7fff` | 정규 |
| 32768 | `0000 8000` | 정규: 양수 부호 보존에 `0000` 필요 |
| -1 | `ffff` | 정규 |
| -32768 | `8000` | 정규 |
| -32769 | `ffff 7fff` | 정규: 음수 부호 보존에 `ffff` 필요 |
| 1 | `0000 0001` | 비정규: 불필요한 선행 `0000` |
| -1 | `ffff ffff` | 비정규: 불필요한 선행 `ffff` |

## 형식 지위

- 2의 보수는 널리 쓰는 관례지만, 임의 정밀도 값을 최소 16비트 WORD열로 정규화해 GEUL TAG와 묶는 이 표현은 GEUL 고유 scalar profile이다.
- INT8/16/32/64 같은 고정 폭 외부 타입과 주고받을 때는 범위 검사와 명시적 폭 변환이 필요하다.
