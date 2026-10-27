---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC ist ein IMPORT-Meta, das ein externes Dokument über einen DOC-POINTER anspricht und ihm eine IMPORT ID zuweist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Importiert ein externes Dokument über eine IMPORT ID. Das zu importierende Dokument wird von einem [DOC-POINTER](/de/grammar/reference/doc-pointer/) angesprochen, der auch die Issuer-Breite trägt.

## Layout

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Reference-Record (Issuer, Dokument-ID, Versions-ID. Bei Version 0 die neueste)
IMPORT ID         der gesamte Rest. unsigned in der kürzesten Breite
```

- Codec: Meta `0x60`, IMPORT-Klasse (`110`)
- Payload: eingebettete Reference `DOC-POINTER` (Issuer, Dokument-ID, Versions-ID) + IMPORT ID als Rohwert
- Anzahl: mehrere möglich (eines je IMPORT ID)

## Interpretation und Gültigkeit

- Das Dokument ist genau ein DOC-POINTER-Record. Er endet mit seiner eigenen Length, der Rest ist die IMPORT ID.
- Die IMPORT ID umfasst mindestens 1 WORD und hat die kürzeste Breite. Die Breite der IMPORT ID wird hier durch die Record-Länge bestimmt, bei [EXTERNAL-POINTER-*](/de/grammar/reference/external-pointer/) durch den Codec. Eine IMPORT ID gilt nur innerhalb ihres Dokuments.
- In einem Dokument wird dieselbe IMPORT ID nicht zweimal vergeben.
- Mit angegebener Versions-ID bindet es an diese Fassung, bei `0` an die zum Zeitpunkt der Interpretation neueste (oder zum angegebenen Zeitpunkt in Kraft befindliche) Fassung ([Revision](/de/grammar/document/#revision)).
- [EXTERNAL-POINTER-*](/de/grammar/reference/external-pointer/) im BODY spricht über die IMPORT ID die LOCALs des importierten Dokuments an. Das importierte Dokument selbst wird per DOC-POINTER angesprochen.
- Der HEAD des importierten Dokuments wird nicht importiert. Die Ziele dieses Dokuments werden gemäß dessen eigenen Deklarationen interpretiert.
- Über die IMPORT ID kann man nicht dokumentübergreifend suchen. Ein Repository, das mehrere Dokumente lädt, löst die IMPORT ID zum vollständigen Pfad (Issuer, Dokument-ID, Versions-ID, LOCAL ID) auf und speichert diesen.

## Beispiel

- IMPORT ID 1, Issuer `0x0001`, Dokument `0x…0002`, neueste Version: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (Meta-TAG 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
