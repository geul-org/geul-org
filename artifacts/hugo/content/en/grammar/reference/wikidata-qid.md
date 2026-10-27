---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID is a declaration Reference that points to a Wikidata item by the number of its Q-ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID is a declaration Reference that points to a Wikidata item. The numeric part of the Q-ID, without the `Q`, is written as an unsigned integer.

## Layout

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length extension TAG]
QID               unsigned big-endian in the shortest width
```

- The QID is written in the shortest width. `Q1` to `Q65535` take 2 WORDs in total; above that it is 3 WORDs.
- Wikidata data is CC0.
- A Variable is an anonymous variable of the kind that the item points to ([Reference](/grammar/reference/), Variable).

## Examples

| Item | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Related Pages

- [Reference](/grammar/reference/), [WIKIDATA-PID](/grammar/reference/wikidata-pid/), [TRIPLE](/grammar/edge/triple/)
