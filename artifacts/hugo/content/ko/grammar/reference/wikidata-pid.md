---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID는 위키데이터 속성(Property)을 P아이디의 숫자로 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID는 위키데이터 속성(Property)을 가리키는 선언 Reference다. P아이디에서 `P`를 뺀 숫자 부분을 부호 없는 정수로 쓴다.

## 레이아웃

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length 확장 TAG]
PID               가장 짧은 폭의 unsigned big-endian
```

- PID는 가장 짧은 폭으로 쓴다. 지금의 속성 번호는 1 WORD에 들어가 전체 2 WORD이며, 65535를 넘으면 3 WORD로 자연히 늘어난다.
- [TRIPLE](/ko/grammar/edge/triple/)의 Predicate, [QUALIFIER](/ko/grammar/edge/qualifier/)의 Property 자리에 주로 쓴다.

## 예시

| 속성 | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/), [TRIPLE](/ko/grammar/edge/triple/), [QUALIFIER](/ko/grammar/edge/qualifier/)
