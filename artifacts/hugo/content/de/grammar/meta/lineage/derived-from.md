---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM ist ein Abstammungs-Meta, das Dokumente oder Material einer anderen Abstammungslinie angibt, von denen dieses Dokument abgeleitet ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält fest, dass dieses Dokument aus Dokumenten oder Material einer anderen Abstammungslinie abgeleitet ist.

## Layout

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length-Erweiterungs-TAG]
Payload           Reference, oder SHA-256-DIGEST (Inhaltshash), oder URI-Value
```

- Codec: Meta `0x31`, Abstammungsklasse (`011`)
- Payload: eingebettete Reference oder Value
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Bei Ableitung aus einem GEUL-Dokument steht dessen Inhaltshash ([SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/)), bei externem Material eine [URI](/de/grammar/value/text/uri/). Um die Fassung des externen Materials per Hash festzulegen, hängt man an das [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) im HEAD einen QUALIFIER für den Originalhash (P4092) an.
- Die Quelle auf Record-Ebene übernimmt das Beleg-Edge [SOURCE](/de/grammar/edge/source/), den früheren Record vor Verschiebung, Teilung oder Zusammenführung der QUALIFIER P1365 (Wert ist die alte Edge Id) am Ziel-Edge.
