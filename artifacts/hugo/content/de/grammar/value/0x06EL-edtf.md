---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF ist ein Value, der mit erweiterten Datumszeichenketten nach ISO 8601-2 Daten mit Jahres- oder Monatsgenauigkeit, vor unserer Zeitrechnung, unsichere Daten und Intervalle aufnimmt (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF ist ein Value, der mit erweiterten Datumszeichenketten nach ISO 8601-2 Daten mit Jahres- oder Monatsgenauigkeit, vor unserer Zeitrechnung, unsichere Daten und Intervalle aufnimmt (Codec 0x06EL/0x06FL).

| Eintrag | Wert |
|---|---|
| Name | `EDTF` (gerade/ungerade Gruppe. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x06EL`·`0x06FL` |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 14 bis 15 |
| Kind | Value · Familie: TIME |
| Index-Beschreibung | EDTF-Datumszeichenkette (ISO 8601-2). Gerade und ungerade Bytezahl. Daten, die mit GREGORIAN-DATE geschrieben werden können, werden nicht damit geschrieben |
| Hugo-Seite | `value/time/edtf.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die beiden Codes des Paars gerade/ungerade gemeinsam. Der gerade Code ist ein Wert mit gerader Bytezahl, der ungerade Code ein Wert mit ungerader Bytezahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder der beiden Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Bytezahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | gerade | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | ungerade | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

EDTF ist ein Value, der Daten als Zeichenkette im [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress, ISO 8601-2:2019) aufnimmt. Er stellt Genauigkeit gröber als Tage, Daten vor unserer Zeitrechnung, unsichere, ungefähre oder teilweise unbekannte Daten und Intervalle dar.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x06EL` (gerade Bytezahl) und `0x06FL` (ungerade Bytezahl). Familie TIME. Der Payload ist eine Zeichenkette, wird aber in der Familie TIME geführt.
- Die Bytezahl ergibt sich aus dem niedrigstwertigen Bit des Codec und der Anzahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niedrigstwertiges Bit`, und es gibt keinen Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = ungerade Bytezahl)
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Payload WORD 1st ... Nth          ASCII-Bytes der EDTF-Zeichenkette / bei ungerader Bytezahl zuletzt 0x00
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge ist eine ASCII-Zeichenkette nach der EDTF-Grammatik der Level 0, 1 und 2. Eine leere Zeichenkette ist invalid.
- Beispiele: Tag `1952-03-11`, Monat `1952-03`, Jahr `1952`, Jahrzehnt `195X`, 44 v. Chr. `-0043`, unsicher `1974?`, ungefähr `~1974`, Intervall `1952/2001`, großes Jahr `Y-13799999999`.
- Die Jahre folgen der astronomischen Zählung nach ISO 8601. `0000` ist das Jahr 1 v. Chr., `-0043` das Jahr 44 v. Chr. Bei der Übertragung aus historischer Schreibweise wird um ein Jahr verschoben.
- Es ist der gregorianische Kalender. EDTF behandelt keine anderen Kalender. Die Originalschreibweise anderer Kalender wie des julianischen wird mit [GEDCOM-DATE](0x070L-gedcom-date.md) bewahrt. Der Wert, der denselben Tag oder Zeitraum dieses Datums in den gregorianischen Kalender überträgt, kann mit EDTF oder GREGORIAN-DATE geschrieben werden.
- **Normalform:** Ein Datum, das sich exakt mit [GREGORIAN-DATE](0x06AL-gregorian-date.md) schreiben lässt, also `[-]YYYY-MM-DD` ohne Qualifikator (`?`, `~`, `%`), unbekannte Stellen (`X`), Intervall und `Y`-Präfix, wird mit GREGORIAN-DATE geschrieben. Ein solches Datum mit EDTF zu schreiben ist invalid. Nur wenn derselbe Tag in einem einzigen Format geschrieben wird, lässt er sich als Zeit indizieren und vergleichen.
- Das Schema prüft die EDTF-Grammatik noch nicht. Der Produzent prüft mit einem EDTF-Parser. Beispiel: `parser.ParseString` von `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` prüft nur die Grammatik und lässt auch `2023-02-29` und `1974-13` durch, wird also nicht verwendet. Dieser Parser unterstützt Jahre mit `Y`-Präfix noch nicht.

## Länge {#길이}

- Die Gesamtzahl ist die Summe der WORD aus 1 WORD TAG, dem Length-Erweiterungs-TAG (falls vorhanden) und dem Payload ([Length](../record.md)).

## Beispiel {#예시}

| Datum | Bytes | Gesamt-WORD |
|---|---|---|
| `1974` | 4 (gerade) | `06E2 3139 3734` |
| `197X` | 4 (gerade) | `06E2 3139 3758` |
| `1952-03` | 7 (ungerade) | `06F4 3139 3532 2D30 3300` |

## Normative Grundlage {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 ist eine Teilmenge von ISO 8601-1, Level 1 und 2 sind Funktionen von ISO 8601-2.
- In RDF wird dieselbe Zeichenkette mit dem Datentyp `http://id.loc.gov/datatypes/edtf` gekennzeichnet.

## Offene Probleme {#열린-문제}

- Die Prüfung der EDTF-Grammatik durch den Prüfer (ob der Prüfer sich auf eine externe Bibliothek stützt).
- Die Regel, mit der die Jahrhundert- und Jahrtausendgenauigkeit von Wikidata in unbekannte Stellen von EDTF übertragen wird.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x000006E0/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `EDTF-EVEN` (`0x06EL`). Beim Codec-Dokument des anderen Mitglieds (`EDTF-ODD`) unterscheiden sich nur die Codec ID im DOC-ID, das DECLARE-Ziel und der in `#1` gebundene Name (BIND).
