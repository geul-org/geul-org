---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM ist ein Abstammungs-Meta, das den Inhaltshash der Ursprungsversion einer aus einer anderen Abstammungslinie übernommenen Änderung festhält (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Inhaltshash der Ursprungsversion einer aus einer anderen Abstammungslinie übernommenen Änderung fest (git cherry-pick `-x`).

## Layout

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x34`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/))
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Das Digest-Format wird als Value eingebettet, damit der Hash-Algorithmus austauschbar bleibt. Derzeit ist der Inhaltshash nur SHA-256.
