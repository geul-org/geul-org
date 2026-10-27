---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER ist ein Value, der eine vorzeichenbehaftete Ganzzahl im Zweierkomplement mit minimaler WORD-Zahl enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER ist ein Value, der einen vorzeichenbehafteten ganzzahligen Wert darstellt. Direkter Value-Code `0x01`, Familie NUMERIC. Der gesamte Payload wird als Zweierkomplement-Ganzzahl beliebiger Genauigkeit in Big-Endian-WORD-Reihenfolge gelesen. Der Payload hat mindestens 1 WORD, und nur die kanonische Darstellung mit minimaler WORD-Zahl ist zulässig.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st  (oberes WORD)   Integer 1st
...
Payload WORD Nth  (unteres WORD)   Integer Nth
```

## Interpretation

- Das höchstwertige Bit des ersten Payload-WORD ist das Vorzeichenbit der gesamten Ganzzahl.
- Alle Payload-WORD werden als eine zusammenhängende Zweierkomplement-Bitfolge gelesen. Das erste WORD ist die höchste Stelle, das letzte die niedrigste.
- Hat der Payload N WORD, beträgt die Interpretationsbreite `16N` Bit. Diese Breite ist keine deklarierte Speicherbreite, sondern die Darstellungsbreite des Wertes, die sich aus der kanonischen Darstellung ergibt.
- Es gibt keinen Byte Count und keinen Bit-Width-Descriptor.

## Kanonische Darstellung

- Die 0 ist der Payload 1 WORD `0000`.
- Führende Vorzeichenerweiterungs-WORD, die den Wert nicht ändern, sind verboten.
- Bei einem Payload ab 2 WORD ist Folgendes nicht kanonisch.
  - Das erste WORD ist `0000` und das höchstwertige Bit des nächsten WORD ist 0
  - Das erste WORD ist `ffff` und das höchstwertige Bit des nächsten WORD ist 1
- Ein führendes `0000`, das das Vorzeichen einer positiven Zahl bewahrt, ist zulässig, wenn das höchstwertige Bit des nächsten WORD 1 ist.
- Ein führendes `ffff`, das das Vorzeichen einer negativen Zahl bewahrt, ist zulässig, wenn das höchstwertige Bit des nächsten WORD 0 ist.
- Ein Decoder muss nicht kanonische Darstellungen ablehnen.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- Deklarierte Breiten wie INT8, INT16 und INT32 werden nicht bewahrt, nur der Zahlenwert. `-32768`~`32767` sind 1 WORD, außerhalb dieses Bereichs kommen nach Bedarf WORD hinzu. Ein eigenes Format SIGNED-INT8 gibt es nicht.

## Beispiel

| Wert | Payload-WORD | Beurteilung |
|---:|---|---|
| 0 | `0000` | kanonisch |
| 1 | `0001` | kanonisch |
| 32767 | `7fff` | kanonisch |
| 32768 | `0000 8000` | kanonisch: Zur Bewahrung des positiven Vorzeichens ist `0000` nötig |
| -1 | `ffff` | kanonisch |
| -32768 | `8000` | kanonisch |
| -32769 | `ffff 7fff` | kanonisch: Zur Bewahrung des negativen Vorzeichens ist `ffff` nötig |
| 1 | `0000 0001` | nicht kanonisch: unnötiges führendes `0000` |
| -1 | `ffff ffff` | nicht kanonisch: unnötiges führendes `ffff` |

## Formatstatus

- Das Zweierkomplement ist eine weit verbreitete Konvention, aber diese Darstellung, die einen Wert beliebiger Genauigkeit auf eine Folge minimaler 16-Bit-WORD normalisiert und mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Beim Austausch mit externen Typen fester Breite wie INT8/16/32/64 sind eine Bereichsprüfung und eine ausdrückliche Breitenkonvertierung nötig.
