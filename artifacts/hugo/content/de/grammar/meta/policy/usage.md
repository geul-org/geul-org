---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE ist ein Richtlinien-Meta, das Nutzungsbeschränkungen wie das Verbot des Trainings oder der kommerziellen Nutzung festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält Nutzungsbeschränkungen fest (z. B. Verbot des Trainings, Verbot der kommerziellen Nutzung).

## Layout

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length-Erweiterungs-TAG]
Payload           Text oder Reference, der die Nutzungsbeschränkung ausdrückt
```

- Codec: Meta `0x55`, Richtlinienklasse (`101`)
- Payload: eingebetteter Value oder Reference
- Anzahl: mehrere möglich

## Offene Fragen

- Codetabelle der Beschränkungsarten.
