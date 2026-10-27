---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS ist ein Abstammungs-Meta, das den Inhaltshash der Version festhält, deren Änderung zurückgenommen wurde (git revert)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Inhaltshash der Version fest, deren Änderung zurückgenommen wurde (git revert).

## Layout

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x35`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/))
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Das Digest-Format wird als Value eingebettet, damit der Hash-Algorithmus austauschbar bleibt. Derzeit ist der Inhaltshash nur SHA-256.
