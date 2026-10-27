---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS ist ein Richtlinien-Meta, das den Zugriffsbereich eines Dokuments (öffentlich, intern, vertraulich) als 1-WORD-Stufe festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Zugriffsbereich des Dokuments fest.

## Layout

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length-Erweiterungs-TAG]
Stufe             1 WORD (0 öffentlich, 1 intern, 2 vertraulich, übrige reserviert)
```

- Codec: Meta `0x51`, Richtlinienklasse (`101`)
- Payload: Rohwert (Stufe 1 WORD)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Vertrauliche Dokumente werden nicht veröffentlicht ([Issuer](/de/grammar/issuer/)).
- Es ändert nicht die Interpretation. Es legt nur den Umgang fest.

## Offene Fragen

- Codetabelle der Stufen.
