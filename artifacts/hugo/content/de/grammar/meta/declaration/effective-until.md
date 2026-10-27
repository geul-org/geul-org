---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL ist ein Definitions-Meta, das das Ende der Gültigkeit dieser Version (befristetes Recht) als Datums- oder Timestamp-Value deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert das Ende der Gültigkeit dieser Version (befristetes Recht). Ab diesem Zeitpunkt ist diese Version nicht mehr in Kraft.

## Layout

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value
```

- Codec: Meta `0x14`, Definitionsklasse (`001`)
- Payload: eingebetteter Value ([GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) oder [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/))
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Fehlt er, ist die Version gültig, bis die nächste Version in Kraft tritt.
- Nach Ablauf der Gültigkeit ist keine Fassung in Kraft. Ältere Fassungen leben nicht wieder auf.
