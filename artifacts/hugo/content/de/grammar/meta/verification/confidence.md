---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE ist ein Verifikations-Meta, das die Konfidenz des gesamten Dokuments als Dezimal-Value von 0 bis 1 festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Konfidenz des gesamten Dokuments fest. Die Konfidenz auf Record-Ebene schreibt man als QUALIFIER, der an das Ziel-Edge angehängt wird (die Property steht noch nicht fest, [SOURCE](/de/grammar/edge/source/#darstellung-weiterer-belege)).

## Layout

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length-Erweiterungs-TAG]
Payload           UNSIGNED-DECIMAL-Value, mindestens 0 und höchstens 1
```

- Codec: Meta `0x43`, Verifikationsklasse (`100`)
- Payload: eingebetteter Value ([UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Wer den Wert vergeben hat, hält man zusätzlich mit [GENERATED-BY](/de/grammar/meta/lineage/generated-by/) o. Ä. fest.

## Offene Fragen

- Die Skala (0~1) und das Verhältnis zum TOULMIN-Urteil.
