---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT ist ein Value, der einen IEEE-754-Binary-Interchange-Skalar darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `BINARY-FLOAT` (Spezifikationsdokument BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000630/` (DECLARE-Ziel `0630`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 3 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | IEEE-754-binary16/32/64/128-Skalar mit Payload von 1/2/4/8 WORD |
| Hugo-Seite | `value/numeric/binary-float.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

BINARY-FLOAT ist ein Value, der einen IEEE-754-Binary-Interchange-Skalar darstellt. Direkter Value-Code `0x063L`, Familie NUMERIC. Ein Payload von 1/2/4/8 WORD ist jeweils binary16/32/64/128. Die Interchange-Bitfolge wird unverändert bewahrt, andere Payload-Größen sind nicht zulässig.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Payload WORD 1st  (oberes WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (unteres WORD)  IEEE Binary Interchange Nth
```

## Interpretation {#해석}

- Die Payload-WORD werden in big-endian-Reihenfolge aneinandergefügt und als IEEE-754-Binary-Interchange-Bitfolge der jeweiligen Breite gelesen.
- Die Interchange-Bitmuster einschließlich NaN-Payload und signed zero werden bewahrt.
- Ein Decoder darf ein NaN nicht durch ein beliebiges kanonisches NaN ersetzen und das Vorzeichen eines signed zero nicht löschen.
- Rundungsverfahren und arithmetisches Verhalten legt dieses Serialisierungsformat nicht fest.

## Länge {#길이}

Die Gesamtzahl ist die Summe der WORD aus 1 WORD TAG, dem Length-Erweiterungs-TAG (falls vorhanden) und dem Payload ([Record und TAG WORD](../record.md)).

| Format | Payload | Length-Code | Length-Erweiterungs-TAG | Gesamtlänge |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | keiner | 2 WORD |
| binary32 | 2 WORD | `0010` | keiner | 3 WORD |
| binary64 | 4 WORD | `0100` | keiner | 5 WORD |
| binary128 | 8 WORD | `1000` | keiner | 9 WORD |

Auch binary128 liegt im direkten Bereich von 1 bis 14 WORD, daher wird kein Length-Erweiterungs-TAG verwendet.

## Gültigkeit {#유효성}

- Der Payload hat genau 1, 2, 4 oder 8 WORD.
- Jede Payload-Größe muss genau zur Length-Darstellung in der obigen Tabelle passen.
- Eine Neucodierung mit geänderter Breite oder Padding-WORD vor oder nach dem Payload sind nicht zulässig.

## Beispiel {#예시}

| Format | TAG | Length-Erweiterungs-TAG | Payload-Beispiel | Beurteilung |
|---|---|---|---|---|
| binary16 | `0631` | keiner | `0000` | kanonisch |
| binary32 | `0632` | keiner | `0000 0000` | kanonisch |
| binary64 | `0634` | keiner | `0000 0000 0000 0000` | kanonisch |
| binary128 | `0638` | keiner | Bitfolge mit 8 WORD | kanonisch |
| beliebig | passt nicht zur von Length angegebenen Größe | beliebig | beliebig | invalid |

## Normative Grundlage {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Die Interchange-Codierungen binary16, binary32, binary64 und binary128 werden angewandt. GEUL fügt dieser Bitfolge nur den TAG und das 16-Bit-WORD-big-endian-Framing hinzu.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000630/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
