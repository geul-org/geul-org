---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE ist ein Value, der eine GEDCOM-7-Datumswert-Zeichenkette enthält und Daten anderer Kalender wie des Julianischen Kalenders so bewahrt, wie sie geschrieben sind (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE ist ein Value, der eine GEDCOM-7-Datumswert-Zeichenkette enthält und Daten anderer Kalender wie des Julianischen Kalenders so bewahrt, wie sie geschrieben sind (Codec 0x070L/0x071L).

| Eintrag | Wert |
|---|---|
| Name | `GEDCOM-DATE` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x070L`·`0x071L` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 16~17 |
| Kind | Value · Familie: TIME |
| Indexbeschreibung | GEDCOM-7-Datumswert-Zeichenkette. Bewahrt die Originalschreibweise anderer Kalender (Julianisch usw.). Gerade/ungerade Bytes |
| Hugo-Pfad | `value/time/gedcom-date.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | gerade | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | ungerade | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

GEDCOM-DATE ist ein Value, der die Zeichenkette des Datumswerts (`DateValue`) von [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch) enthält. Ein Datum, das die Quelle in einem anderen Kalender als dem Gregorianischen (Julianisch usw.) geschrieben hat, wird **so bewahrt, wie es geschrieben ist**.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x070L` (gerade Bytes) und `0x071L` (ungerade Bytes). Familie TIME.
- Die Byteanzahl ergibt sich aus dem niedrigstwertigen Bit des Codecs und der Anzahl der Payload-WORDs. Sie ist `2 × Anzahl der Payload-WORDs − niedrigstwertiges Bit`; einen Byte Count gibt es nicht ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = ungerade Bytes)
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st ... Nth          ASCII-Bytes der GEDCOM-Datumszeichenkette / bei ungerader Anzahl letztes 0x00
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge ist eine ASCII-Zeichenkette nach der GEDCOM-7-Grammatik `DateValue`. Eine leere Zeichenkette ist invalid. GEDCOM erlaubt einen leeren `DateValue`, aber wenn kein Wert vorhanden ist, wird kein Record geschrieben.
- Grammatik im Überblick: `[Kalender] [[Tag] Monat] Jahr [BCE]`. Davor stehen `ABT`·`CAL`·`EST` (ungefähr), `BEF`·`AFT`·`BET … AND …` (Bereich) und `FROM … TO …` (Zeitraum). Das Trennzeichen ist ein einzelnes Leerzeichen.
- Kalender: `GREGORIAN` (Standard, wenn weggelassen), `JULIAN`, `FRENCH_R`, `HEBREW`, Erweiterungs-Tags. Die Monatsnamen sind je Kalender festgelegt (der Julianische Kalender hat dieselben `JAN`…`DEC` wie der Gregorianische).
- Jahre sind **historisch** gezählt. Es gibt kein Jahr 0, und v. Chr. wird mit `BCE` angehängt (`44 BCE` = 44 v. Chr.). Das weicht um ein Jahr von der astronomischen Zählung in EDTF und GREGORIAN-DATE ab.
- Das Schema prüft nur das Byteformat: ASCII `0x20`~`0x7E`, nicht leer, keine Leerzeichen am Anfang und Ende. Grammatik und Existenz des Tages prüft der Erzeuger. Beispiel: `gedcom.ParseDate` aus `github.com/cacack/gedcom-go/v3` (MIT). `Validate` dieser Bibliothek prüft Tage nur im Gregorianischen Kalender und lässt daher `JULIAN 30 FEB 1100` durch; `ToGregorian` wandelt Jahres- und Monatsgenauigkeit nicht tatsächlich um. Die Existenzprüfung und Normalisierung von Daten erfolgen gesondert.
- **Verwendung:** Gregorianische Daten werden mit [GREGORIAN-DATE](0x06AL-gregorian-date.md) oder [EDTF](0x06EL-edtf.md) geschrieben. GEDCOM-DATE wird für Daten anderer Kalender verwendet, deren Originalschreibweise bewahrt werden muss.

## Zusammen mit normalisierten Werten verwenden {#정규화된-값과-함께-쓰기}

- Um dasselbe Datum auf der Zeitachse zu vergleichen und zu indizieren, wird ein Gregorianischer Wert benötigt. Bei Tagesgenauigkeit ist das ein GREGORIAN-DATE desselben Tages, bei Jahres- und Monatsgenauigkeit ein EDTF-Intervall des Gregorianischen Kalenders für diesen Zeitraum (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Wie die Originalschreibweise (GEDCOM-DATE) und der normalisierte Wert als zwei Values zusammen abgelegt werden, ist noch nicht festgelegt (offenes Problem).

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload ([Length](../record.md)).

## Beispiel {#예시}

| Datum | Bytes | Gesamt-WORDs |
|---|---|---|
| `JULIAN 1300` | 11 (ungerade) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Normative Grundlage {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). Die Lizenz des Spezifikations-Repositorys ist Apache 2.0. GEUL verweist nur auf das Format und übernimmt den Spezifikationstext nicht.
- ISO 8601, EDTF, XSD und die CLDR-Kalenderkennung (`u-ca`) kennen den Julianischen Kalender nicht. GEDCOM 7 ist ein offenes Austauschformat, das Kalenderpräfix, v. Chr., Genauigkeit und Qualifikatoren in einer Grammatik behandelt.

## Offene Probleme {#열린-문제}

- Wie Originalschreibweise und normalisierter Wert zusammen geschrieben werden (wie beide in einem TRIPLE verbunden werden).
- Die GEDCOM-Grammatikprüfung im Schema.
- Jahrhundert- und Jahrzehntgenauigkeit. GEDCOM hat dafür kein Format. Daten, die sich aus Wikidata nicht übernehmen lassen, bleiben als Originaltext in UTF8-TEXT.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000700/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `GEDCOM-DATE-EVEN` (`0x070L`). Das Codec-Dokument des anderen Mitglieds (`GEDCOM-DATE-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
