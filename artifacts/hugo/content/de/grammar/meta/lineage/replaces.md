---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES ist ein Abstammungs-Meta, das den Inhaltshash der überarbeiteten Zielversion festhält (git amend/rebase). Die ursprüngliche Version wird nicht gelöscht."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Inhaltshash der überarbeiteten Zielversion fest (git amend/rebase).

## Layout

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x36`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/))
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Die ursprüngliche Version wird nicht gelöscht (Bewahrung des alten Rechts).
- Das Digest-Format wird als Value eingebettet, damit der Hash-Algorithmus austauschbar bleibt. Derzeit ist der Inhaltshash nur SHA-256.
