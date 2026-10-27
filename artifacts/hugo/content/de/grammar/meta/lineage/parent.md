---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT ist ein Abstammungs-Meta, das den Inhaltshash der unmittelbar vorherigen Version festhält (git parent). Mehrere bedeuten einen Merge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Inhaltshash der unmittelbar vorherigen Version fest (git parent).

## Layout

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x30`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/))
- Anzahl: mehrere möglich (Merge)

## Interpretation und Gültigkeit

- Fehlt es, ist es die erste Version; mehrere bedeuten einen Merge (git merge commit).
- Da es in den [Inhaltshash](/de/grammar/document/#inhaltshash) eingeht, bildet die gesamte Historie eine Hashkette.
- Das Versionslisten-Dokument verweist auf das vorherige Listendokument ([PUBLICATION](/de/grammar/edge/publication/)).
- Das Digest-Format wird als Value eingebettet, damit der Hash-Algorithmus austauschbar bleibt. Derzeit ist der Inhaltshash nur SHA-256.

## Beispiel

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length-Erweiterung + eingebetteter Value 18 WORD)
