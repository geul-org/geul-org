---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM ist ein Definitions-Meta, das das Inkrafttreten dieser Version als Datums- oder Timestamp-Value deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert das Inkrafttreten dieser Version. Es unterscheidet sich vom Veröffentlichungszeitpunkt ([Revision](/de/grammar/document/#revision)).

## Layout

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value
```

- Codec: Meta `0x13`, Definitionsklasse (`001`)
- Payload: eingebetteter Value ([GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) oder [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/))
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Fehlt er, gilt die Version ab dem Veröffentlichungszeitpunkt.
- Ist [EFFECTIVE-UNTIL](/de/grammar/meta/declaration/effective-until/) vorhanden, muss dieser Wert davor liegen.
- Weicht das Inkrafttreten je Artikel ab, wird es am Artikel-Edge getrennt mit QUALIFIER P580 (Beginn) und P582 (Ende) angegeben ([SOURCE](/de/grammar/edge/source/#darstellung-weiterer-belege)).
- Wird das Dokument auf einen bestimmten Zeitpunkt bezogen interpretiert, liest man diesen Wert.

## Beispiel

- In Kraft seit 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
