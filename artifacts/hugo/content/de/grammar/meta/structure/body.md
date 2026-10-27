---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY ist ein 1-WORD-Struktur-Meta, das den HEAD eines Dokuments beendet und den BODY beginnt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Record, der den HEAD beendet und den BODY beginnt.

## Layout

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length-Erweiterungs-TAG]
```

- Codec: Meta `0x0E`, Strukturklasse (`000`)
- Payload: keiner (1 WORD)
- Anzahl: höchstens einer je Dokument

## Interpretation und Gültigkeit

- Ist der HEAD leer, entfällt er. Ein Dokument ohne `BODY` besteht ganz aus BODY. Enthält der HEAD Meta oder HEAD-Edges (das [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) für das gesamte Dokument und dessen QUALIFIER), steht er.
- Es gibt keinen Payload. Der Record ist insgesamt 1 WORD lang.

## Beispiel

- `0x180E`
