---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT ist ein Richtlinien-Meta, das Umfang und Grundlage der Einwilligung als Reference oder Text festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält Umfang und Grundlage der Einwilligung fest.

## Layout

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length-Erweiterungs-TAG]
Payload           Reference oder Text, der auf die Grundlage der Einwilligung verweist
```

- Codec: Meta `0x54`, Richtlinienklasse (`101`)
- Payload: eingebettetes Reference oder Value
- Anzahl: mehrere möglich

## Offene Fragen

- Struktur der Umfangsdarstellung (Zweck, Dauer, Weitergabe an Dritte).
