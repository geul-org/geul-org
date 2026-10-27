---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL은 논리값 false와 true를 담는 고정 2 WORD Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL은 논리값 false와 true를 나타내는 Value다. Value 직접 코드 `0x00`, 계열 NUMERIC이다. 숫자 0과 1을 담는 SIGNED-INTEGER·UNSIGNED-INTEGER와는 다른 타입이다.

## 레이아웃

```
TAG WORD          0x0880 (0000 1000 1000 0000)  전체 2 WORD
Payload           1 WORD  Boolean Code
```

## 해석과 유효성

- Payload `0000`은 false, `0001`은 true다.
- padding이나 descriptor는 없다.
- Payload는 정확히 `0000` 또는 `0001`이다. 그 밖의 16비트 값은 invalid로 거부한다.
- 다른 Length 표현은 모두 invalid로 거부한다.

## 길이

- 전체는 TAG 1 WORD와 Payload 1 WORD를 합한 정확히 2 WORD이고 직접 길이 `LLLL=0001`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 1 WORD가 아니면 거부한다.

## 예시

| 전체 레코드 (TAG + Payload) | Payload | 판정 |
|---|---|---|
| `0880 0000` | `0000` | false, 정규 |
| `0880 0001` | `0001` | true, 정규 |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| Length가 `0001`이 아닌 TAG + `0000` 또는 `0001` | `0000` 또는 `0001` | invalid |

## 형식 지위

- `0000`/`0001`의 16비트 code word와 GEUL TAG를 묶은 이 표현은 GEUL 고유 scalar profile이다.
- 논리값 자체는 보편적이지만, 이 1 WORD 표현에 대응하는 단일 산업표준을 주장하지 않는다.
