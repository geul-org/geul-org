---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION ist ein Richtlinien-Meta, das die Aufbewahrungsfrist eines Dokuments als Ablaufzeitpunkt oder Dauer-Value festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Aufbewahrungsfrist des Dokuments fest.

## Layout

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length-Erweiterungs-TAG]
Payload           Ablaufzeitpunkt (GREGORIAN-DATE usw.) oder Dauer (DURATION-SECONDS)
```

- Codec: Meta `0x53`, Richtlinienklasse (`101`)
- Payload: eingebetteter Value (TIME-Familie: [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) usw. oder [DURATION-SECONDS](/de/grammar/value/time/duration-seconds/))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Bei einer Dauer zählt man ab [RECORDED-AT](/de/grammar/meta/provenance/recorded-at/).
