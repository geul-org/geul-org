---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID는 위키데이터 항목(Item)을 Q아이디의 숫자로 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID는 위키데이터 항목(Item)을 가리키는 선언 Reference다. Q아이디에서 `Q`를 뺀 숫자 부분을 부호 없는 정수로 쓴다.

## 레이아웃

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length 확장 TAG]
QID               가장 짧은 폭의 unsigned big-endian
```

- QID는 가장 짧은 폭으로 쓴다. `Q1`~`Q65535`는 전체 2 WORD, 그 위는 3 WORD다.
- 위키데이터 데이터는 CC0다.
- Variable이면 그 항목이 가리키는 종류의 익명 변수다([Reference](/ko/grammar/reference/) Variable).

## 예시

| 항목 | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/), [TRIPLE](/ko/grammar/edge/triple/)
