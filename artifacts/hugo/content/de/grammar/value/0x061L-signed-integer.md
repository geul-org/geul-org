---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER ist ein Value, der vorzeichenbehaftete Ganzzahlwerte darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SIGNED-INTEGER` (Spezifikationsdokument BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000610/` (DECLARE-Ziel `0610`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 1 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | vorzeichenbehaftete Ganzzahl im Zweierkomplement mit minimaler WORD-Anzahl |
| Hugo-Seite | `value/numeric/signed-integer.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

SIGNED-INTEGER ist ein Value, der vorzeichenbehaftete Ganzzahlwerte darstellt. Direkter Value-Code `0x061L`, Familie NUMERIC. Der gesamte Payload wird als Zweierkomplement-Ganzzahl beliebiger Genauigkeit in big-endian-WORD-Reihenfolge gelesen. Der Payload hat mindestens 1 WORD, und nur die kanonische Darstellung mit minimaler WORD-Anzahl ist zulässig.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Payload WORD 1st  (oberes WORD)   Integer 1st
...
Payload WORD Nth  (unteres WORD)  Integer Nth
```

## Interpretation {#해석}

- Das höchstwertige Bit des ersten Payload-WORD ist das Vorzeichenbit der gesamten Ganzzahl.
- Alle Payload-WORD werden als eine zusammenhängende Zweierkomplement-Bitfolge gelesen. Das erste WORD ist die höchste Stelle, das letzte WORD die niedrigste.
- Hat der Payload N WORD, beträgt die Interpretationsbreite `16N` Bit. Diese Breite ist keine deklarierte Speicherbreite, sondern die Darstellungsbreite des Werts, die sich aus der kanonischen Darstellung ergibt.
- Es gibt weder Byte Count noch Bitbreiten-Descriptor.

## Kanonische Darstellung {#정규-표현}

- 0 ist der Payload `0000` mit 1 WORD.
- Führende Vorzeichenerweiterungs-WORD, die den Wert nicht ändern, sind verboten.
- Bei einem Payload von 2 WORD oder mehr sind folgende Fälle nicht kanonisch.
  - Das erste WORD ist `0000` und das höchstwertige Bit des nächsten WORD ist 0
  - Das erste WORD ist `FFFF` und das höchstwertige Bit des nächsten WORD ist 1
- Ein führendes `0000`, das das Vorzeichen einer positiven Zahl bewahrt, ist zulässig, wenn das höchstwertige Bit des nächsten WORD 1 ist.
- Ein führendes `FFFF`, das das Vorzeichen einer negativen Zahl bewahrt, ist zulässig, wenn das höchstwertige Bit des nächsten WORD 0 ist.
- Ein Decoder muss nicht kanonische Darstellungen ablehnen.

## Länge {#길이}

- Die Gesamtzahl ist die Summe der WORD aus 1 WORD TAG, dem Length-Erweiterungs-TAG (falls vorhanden) und dem Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`·`1111`, und auch der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](../record.md)).
- Deklarierte Breiten wie INT8, INT16 und INT32 werden nicht bewahrt, nur der Zahlenwert. `-32768` bis `32767` belegen 1 WORD, außerhalb dieses Bereichs kommen so viele WORD hinzu, wie nötig sind. Ein eigenes Format SIGNED-INT8 gibt es nicht.

## Beispiel {#예시}

| Wert | Payload-WORD | Beurteilung |
|---:|---|---|
| 0 | `0000` | kanonisch |
| 1 | `0001` | kanonisch |
| 32767 | `7FFF` | kanonisch |
| 32768 | `0000 8000` | kanonisch: `0000` ist nötig, um das positive Vorzeichen zu bewahren |
| -1 | `FFFF` | kanonisch |
| -32768 | `8000` | kanonisch |
| -32769 | `FFFF 7FFF` | kanonisch: `FFFF` ist nötig, um das negative Vorzeichen zu bewahren |
| 1 | `0000 0001` | nicht kanonisch: überflüssiges führendes `0000` |
| -1 | `FFFF FFFF` | nicht kanonisch: überflüssiges führendes `FFFF` |

## Formatstatus {#형식-지위}

- Das Zweierkomplement ist eine weit verbreitete Konvention, aber diese Darstellung, die Werte beliebiger Genauigkeit zu einer Folge von WORD mit mindestens 16 Bit normalisiert und mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Beim Austausch mit externen Typen fester Breite wie INT8/16/32/64 sind eine Bereichsprüfung und eine explizite Breitenkonvertierung nötig.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000610/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
