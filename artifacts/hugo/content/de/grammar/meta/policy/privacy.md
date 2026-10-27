---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY ist ein Richtlinien-Meta, das die Datenschutzstufe eines Dokuments in 1 WORD festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Datenschutzstufe des Dokuments fest.

## Layout

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length-Erweiterungs-TAG]
Stufe             1 WORD
```

- Codec: Meta `0x52`, Richtlinienklasse (`101`)
- Payload: Rohwert (Stufe 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Es ändert nicht die Interpretation. Es legt nur den Umgang fest.

## Offene Fragen

- Codetabelle der Stufen (Zuordnung zur Klassifikation des koreanischen Datenschutzgesetzes).
