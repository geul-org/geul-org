---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END ist ein 1-WORD-Struktur-Meta, das das Dokument schließt. Es ist in jedem Dokument Pflicht."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Der Record, der das Dokument schließt.

## Layout

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length-Erweiterungs-TAG]
```

- Codec: Meta `0x0F`, Strukturklasse (`000`)
- Payload: keiner (1 WORD)
- Anzahl: eines je Dokument, ganz am Ende

## Interpretation und Gültigkeit

- Pflicht. Die Position wird anhand der Länge von [DOC](/de/grammar/meta/structure/doc/) (`DOC-*`) geprüft.
- Endet die Eingabe ohne END, ist das Dokument abgeschnitten. Ob der Inhalt eines abgeschnittenen Dokuments als gültig gilt, ist Sache der Decoder-Richtlinie.
- Danach folgt nichts mehr.

## Beispiel

- `0x180F`
