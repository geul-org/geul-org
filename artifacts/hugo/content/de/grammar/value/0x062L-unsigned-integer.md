---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER ist ein Value, der vorzeichenlose Ganzzahlwerte darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `UNSIGNED-INTEGER` (Spezifikationsdokument BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000620/` (DECLARE-Ziel `0620`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 2 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | Ganzzahl als big-endian Unsigned Magnitude mit minimaler WORD-Anzahl |
| Hugo-Seite | `value/numeric/unsigned-integer.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

UNSIGNED-INTEGER ist ein Value, der vorzeichenlose Ganzzahlwerte darstellt. Direkter Value-Code `0x062L`, Familie NUMERIC. Der gesamte Payload wird als Unsigned Magnitude beliebiger Genauigkeit in big-endian-WORD-Reihenfolge gelesen. Der Payload hat mindestens 1 WORD, und nur die kanonische Darstellung mit minimaler WORD-Anzahl ist zulässig.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Payload WORD 1st  (oberes WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (unteres WORD)  Unsigned Magnitude Nth
```

## Interpretation {#해석}

- Das erste Payload-WORD ist die höchste Stelle, das letzte WORD die niedrigste.
- Hat der Payload N WORD, wird er als eine einzige `16N`-Bit-Unsigned-Magnitude gelesen.
- Diese Breite ist keine deklarierte Speicherbreite, und es gibt keinen Bitbreiten-Descriptor.

## Kanonische Darstellung {#정규-표현}

- 0 ist der Payload `0000` mit 1 WORD.
- Bei einem Payload von 2 WORD oder mehr ist ein erstes WORD `0000` nicht kanonisch, da der Wert auch ohne es gleich bleibt.
- Ein Decoder muss Darstellungen mit überflüssigen führenden Null-WORD ablehnen.

## Länge {#길이}

- Die Gesamtzahl ist die Summe der WORD aus 1 WORD TAG, dem Length-Erweiterungs-TAG (falls vorhanden) und dem Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`·`1111`, und auch der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](../record.md)).
- Deklarierte Breiten wie UINT8, UINT16 und UINT32 werden nicht bewahrt, nur der Zahlenwert.

## Beispiel {#예시}

| Wert | Payload-WORD | Beurteilung |
|---:|---|---|
| 0 | `0000` | kanonisch |
| 1 | `0001` | kanonisch |
| 65535 | `FFFF` | kanonisch |
| 65536 | `0001 0000` | kanonisch |
| 1 | `0000 0001` | nicht kanonisch: überflüssiges führendes `0000` |
| Payload mit 7 WORD | die 7 WORD nach dem TAG `0627` (direkte Länge `LLLL=0111`, insgesamt 8 WORD) | kanonisch |
| Payload mit 7 WORD | die 7 WORD nach einem Length-Erweiterungs-TAG mit Erweiterungswert `0009` | nicht kanonisch: bis 14 WORD wird die direkte Länge verwendet |

## Formatstatus {#형식-지위}

- Diese Darstellung, die eine Unsigned Magnitude beliebiger Genauigkeit zu einer Folge von WORD mit mindestens 16 Bit normalisiert und mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Beim Austausch mit externen Typen fester Breite wie UINT8/16/32/64 sind eine Bereichsprüfung und eine explizite Breitenkonvertierung nötig.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000620/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
