---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY ist ein Verifikations-Meta, das Signaturalgorithmus-ID und öffentlichen Schlüssel eines selbst ausgestellten (16 WORD) Issuers deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert den öffentlichen Schlüssel eines selbst ausgestellten (16 WORD) Issuers. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ Algorithmus-ID ‖ öffentlicher Schlüssel) ([16-WORD-Issuer](/de/grammar/issuer/#16-word-issuer)).

## Layout

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length-Erweiterungs-TAG]
Algorithmus-ID    1 WORD (0x0001 = Ed25519)
Öffentl. Schlüssel  vom Algorithmus festgelegte Breite (Ed25519 16 WORD)
```

- Codec: Meta `0x40`, Verifikationsklasse (`100`)
- Payload: Rohwert (Algorithmus-ID + öffentlicher Schlüssel)
- Anzahl: mehrere möglich (Schlüsselwechsel)

## Interpretation und Gültigkeit

- Als Verifikationsklasse bleibt es beim Inhaltshash außen vor.
- 1-, 2- und 4-WORD-Issuer verwenden den bei geul.org registrierten Schlüssel und brauchen es nicht.
