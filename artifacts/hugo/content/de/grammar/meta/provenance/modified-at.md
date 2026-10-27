---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT ist ein Herkunfts-Meta, das den Zeitpunkt der Änderung des Dokuments als TIME-Value festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Zeitpunkt fest, zu dem das Dokument geändert wurde.

## Layout

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS usw.)
```

- Codec: Meta `0x23`, Herkunftsklasse (`010`)
- Payload: eingebetteter Value (TIME-Familie: [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/) usw.)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Das Format wird unter den Values der TIME-Familie gewählt. Braucht man höhere Genauigkeit, verwendet man ein vom Issuer definiertes Nanosekundenformat (z. B. [POSIX-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/posix-timestamp-nanoseconds/)).
