---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT ist ein Herkunfts-Meta, das den Zeitpunkt der Aufzeichnung als Dokument als TIME-Value festhält (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Zeitpunkt fest, zu dem das Dokument aufgezeichnet wurde (git commit date).

## Layout

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS usw.)
```

- Codec: Meta `0x25`, Herkunftsklasse (`010`)
- Payload: eingebetteter Value (TIME-Familie: [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/) usw.)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Das Format wird unter den Values der TIME-Familie gewählt. Braucht man höhere Genauigkeit, verwendet man ein vom Issuer definiertes Nanosekundenformat (z. B. [POSIX-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/posix-timestamp-nanoseconds/)).
- Versionslisten-Dokumente ([PUBLICATION](/de/grammar/edge/publication/)) verwenden diesen Wert als Zeitpunkt von Veröffentlichung, Deprecation und Löschung.

## Offene Fragen

- Herkunfts-Meta gehen in den Inhaltshash ein. Ob zugelassen wird, dass derselbe Inhalt, zu einem anderen Zeitpunkt aufgezeichnet, einen anderen Hash ergibt.
