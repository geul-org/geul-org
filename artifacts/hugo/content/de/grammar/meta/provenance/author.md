---
title: "AUTHOR"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "AUTHOR ist ein Herkunfts-Meta, das die Instanz, die den Dokumentinhalt verfasst hat, als Reference festhält (git author)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Instanz fest, die den Dokumentinhalt verfasst hat (git author).

## Layout

```
TAG WORD          0001 1LLL L010 0000      Codec 0x20
[Length-Erweiterungs-TAG]
Payload           ein Reference-Record (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL usw.)
```

- Codec: Meta `0x20`, Herkunftsklasse (`010`)
- Payload: eingebettetes Reference
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Das Reference ist nicht auf einen Codec beschränkt. Es kann ein Mensch, eine Organisation, ein Modell oder eine Regelmaschine sein ([EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [GEUL](/de/grammar/reference/geul/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/), [LOCAL](/de/grammar/reference/local/) usw.).
- In bei geul.org veröffentlichten Dokumenten steht kein Reference, das auf eine natürliche Person verweist ([Issuer und Veröffentlichung](/de/grammar/issuer/#veröffentlichung-bei-geulorg)). Es verweist auf eine Organisation oder einen Issuer. Ausnahmsweise ist der Verweis auf natürliche Personen über [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) zulässig.
- Bei LOCAL beschreibt man dieses Objekt im BODY.
