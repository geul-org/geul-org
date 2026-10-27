---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT ist ein Herkunfts-Meta, das den Zeitpunkt der Erstellung des Dokuments als TIME-Value festhält (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Zeitpunkt fest, zu dem das Dokument erstellt wurde (git author date).

## Layout

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length-Erweiterungs-TAG]
Payload           ein TIME-Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS usw.)
```

- Codec: Meta `0x22`, Herkunftsklasse (`010`)
- Payload: eingebetteter Value (TIME-Familie: [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/) usw.)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Das Format wird unter den Values der TIME-Familie gewählt. Braucht man höhere Genauigkeit, verwendet man ein vom Issuer definiertes Nanosekundenformat (z. B. [POSIX-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/posix-timestamp-nanoseconds/)).
