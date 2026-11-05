---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL ist ein Value, der die Wahrheitswerte false und true darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `BOOL` (Spezifikationsdokument BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000600/` (DECLARE-Ziel `0600`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 0 |
| Kind | Value · Familie: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | false oder true in festen 1 WORD |
| Hugo-Seite | `value/numeric/bool.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | Rohwert 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL ist ein Value, der die Wahrheitswerte false und true darstellt. Direkter Value-Code `0x060L`, Familie NUMERIC. Es ist ein anderer Typ als SIGNED-INTEGER und UNSIGNED-INTEGER, die die Zahlen 0 und 1 enthalten.

## Layout {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  insgesamt 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Payload `0000` ist false, `0001` ist true.
- Es gibt weder Padding noch Descriptor.
- Der Payload ist genau `0000` oder `0001`. Jeder andere 16-Bit-Wert wird als invalid abgelehnt.
- Jede andere Length-Darstellung wird als invalid abgelehnt.

## Länge {#길이}

- Insgesamt sind es genau 2 WORD aus 1 WORD TAG und 1 WORD Payload, mit der direkten Länge `LLLL=0001`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 1 WORD, wird abgelehnt.

## Beispiel {#예시}

| Gesamter Record (TAG + Payload) | Payload | Beurteilung |
|---|---|---|
| `0601 0000` | `0000` | false, kanonisch |
| `0601 0001` | `0001` | true, kanonisch |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG mit einer anderen Length als `0001` + `0000` oder `0001` | `0000` oder `0001` | invalid |

## Formatstatus {#형식-지위}

- Diese Darstellung, die das 16-Bit-Codewort `0000`/`0001` mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Der Wahrheitswert selbst ist universell, aber für diese 1-WORD-Darstellung wird kein einzelner Industriestandard behauptet.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000600/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
