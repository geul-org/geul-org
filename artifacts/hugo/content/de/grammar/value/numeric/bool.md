---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL ist ein Value mit festen 2 WORD, der die Wahrheitswerte false und true enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL ist ein Value, der die Wahrheitswerte false und true darstellt. Direkter Value-Code `0x00`, Familie NUMERIC. Es ist ein anderer Typ als SIGNED-INTEGER und UNSIGNED-INTEGER, die die Zahlen 0 und 1 enthalten.

## Layout

```
TAG WORD          0x0880 (0000 1000 1000 0000)  insgesamt 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretation und Gültigkeit

- Der Payload `0000` ist false, `0001` ist true.
- Es gibt weder Padding noch Descriptor.
- Der Payload ist genau `0000` oder `0001`. Jeder andere 16-Bit-Wert wird als invalid abgelehnt.
- Jede andere Length-Darstellung wird als invalid abgelehnt.

## Länge

- Insgesamt sind es genau 2 WORD aus 1 WORD TAG und 1 WORD Payload, mit der direkten Länge `LLLL=0001`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 1 WORD, wird abgelehnt.

## Beispiel

| Gesamter Record (TAG + Payload) | Payload | Beurteilung |
|---|---|---|
| `0880 0000` | `0000` | false, kanonisch |
| `0880 0001` | `0001` | true, kanonisch |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG mit einer anderen Length als `0001` + `0000` oder `0001` | `0000` oder `0001` | invalid |

## Formatstatus

- Diese Darstellung, die das 16-Bit-Codewort `0000`/`0001` mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Der Wahrheitswert selbst ist universell, aber für diese 1-WORD-Darstellung wird kein einzelner Industriestandard behauptet.
