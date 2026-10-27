---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT ist ein Verifikations-Meta, das das Urteilsergebnis über das gesamte Dokument (Pass, Review, Fail) in 1 WORD festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält das Urteilsergebnis über das gesamte Dokument fest. Urteile auf Ebene von Knoten und Records übernimmt das [TOULMIN](/de/grammar/edge/toulmin/)-`VERDICT` (Edge `0x78`).

## Layout

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length-Erweiterungs-TAG]
Urteil            1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, Verifikationsklasse (`100`)
- Payload: Rohwert (Urteil 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Als Verifikationsklasse bleibt es beim Inhaltshash außen vor.
- Ein Urteil über ein anderes Dokument steht im BODY eines Dokuments, das vom Urteilsgegenstand verschieden ist.

## Offene Fragen

- Ob Urteilende Instanz und Begründung mit festgehalten werden sollen.
