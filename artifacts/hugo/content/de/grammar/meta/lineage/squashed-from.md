---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM ist ein Abstammungs-Meta, das die Inhaltshashes der zu einer Version zusammengefassten Ursprungsversionen festhält (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Inhaltshashes der zu einer Version zusammengefassten Ursprungsversionen fest (git squash).

## Layout

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x37`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/))
- Anzahl: mehrere möglich (eines je Ursprungsversion)

## Interpretation und Gültigkeit

- Das Digest-Format wird als Value eingebettet, damit der Hash-Algorithmus austauschbar bleibt. Derzeit ist der Inhaltshash nur SHA-256.
