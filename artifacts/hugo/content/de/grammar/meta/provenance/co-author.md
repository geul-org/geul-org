---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR ist ein Herkunfts-Meta, das die Instanz, die das Dokument mitverfasst hat, als Reference festhält (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Instanz fest, die das Dokument mitverfasst hat (git `Co-authored-by`).

## Layout

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[Length-Erweiterungs-TAG]
Payload           ein Reference-Record (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL usw.)
```

- Codec: Meta `0x21`, Herkunftsklasse (`010`)
- Payload: eingebettetes Reference
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Das Reference ist nicht auf einen Codec beschränkt. Es kann ein Mensch, eine Organisation, ein Modell oder eine Regelmaschine sein ([EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [GEUL](/de/grammar/reference/geul/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/), [LOCAL](/de/grammar/reference/local/) usw.).
- In bei geul.org veröffentlichten Dokumenten steht kein Reference, das auf eine natürliche Person verweist ([Issuer und Veröffentlichung](/de/grammar/issuer/#veröffentlichung-bei-geulorg)). Es verweist auf eine Organisation oder einen Issuer. Ausnahmsweise ist der Verweis auf natürliche Personen über [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) zulässig.
- Bei LOCAL beschreibt man dieses Objekt im BODY.
