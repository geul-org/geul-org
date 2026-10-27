---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID is a declaration Reference that points to a Wikidata property by the number of its P-ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID is a declaration Reference that points to a Wikidata property. The numeric part of the P-ID, without the `P`, is written as an unsigned integer.

## Layout

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length extension TAG]
PID               unsigned big-endian in the shortest width
```

- The PID is written in the shortest width. Current property numbers fit in 1 WORD, making 2 WORDs in total; above 65535 it naturally grows to 3 WORDs.
- It is used mainly in the Predicate position of [TRIPLE](/grammar/edge/triple/) and the Property position of [QUALIFIER](/grammar/edge/qualifier/).

## Examples

| Property | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Related Pages

- [Reference](/grammar/reference/), [WIKIDATA-QID](/grammar/reference/wikidata-qid/), [TRIPLE](/grammar/edge/triple/), [QUALIFIER](/grammar/edge/qualifier/)
