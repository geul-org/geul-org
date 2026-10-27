---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF ist ein Verifikations-Meta, das die Bestätigung des Beitragsrechts als Reference festhält (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Bestätigung des Beitragsrechts (git `Signed-off-by`, DCO).

## Layout

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length-Erweiterungs-TAG]
Payload           ein Reference
```

- Codec: Meta `0x42`, Verifikationsklasse (`100`)
- Payload: eingebettetes Reference
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- In bei geul.org veröffentlichten Dokumenten steht kein Reference, das auf eine natürliche Person verweist ([Issuer und Veröffentlichung](/de/grammar/issuer/#veröffentlichung-bei-geulorg)). Es verweist auf eine Organisation oder einen Issuer. Ausnahmsweise ist der Verweis auf natürliche Personen über [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) zulässig.
