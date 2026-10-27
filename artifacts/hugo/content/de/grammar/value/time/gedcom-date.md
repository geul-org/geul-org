---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE ist ein Value, der Daten anderer Kalender wie des Julianischen als GEDCOM-7-Datumswert-Zeichenkette so bewahrt, wie sie geschrieben sind (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE ist ein Value, der eine Datumswert-Zeichenkette (`DateValue`) von [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch) enthält. Er bewahrt ein Datum, das das Original in einem anderen Kalender als dem gregorianischen (Julianisch usw.) geschrieben hat, **so, wie es geschrieben ist**.

## Layout

- Code: direkter Value-Code `0x26` (gerade Bytezahl) und `0x27` (ungerade Bytezahl). Familie TIME.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit des Codec und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = ungerade Bytezahl)
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st ... Nth          ASCII-Bytes der GEDCOM-Datumszeichenkette / bei ungerader Zahl zuletzt 0x00
```

## Interpretation und Gültigkeit

- Die Bytefolge ist eine ASCII-Zeichenkette nach der Grammatik `DateValue` von GEDCOM 7. Eine leere Zeichenkette ist invalid. GEDCOM lässt ein leeres `DateValue` zu, aber gibt es keinen Wert, wird kein Record geschrieben.
- Grammatik in Kürze: `[Kalender] [[Tag] Monat] Jahr [BCE]`. Davor können `ABT`, `CAL`, `EST` (ungefähr), `BEF`, `AFT`, `BET … AND …` (Bereich) und `FROM … TO …` (Zeitraum) stehen. Trennzeichen ist ein einzelnes Leerzeichen.
- Kalender: `GREGORIAN` (bei Auslassung der Standard), `JULIAN`, `FRENCH_R`, `HEBREW`, erweiterte Tags. Die Monatsnamen sind je Kalender festgelegt (der Julianische hat dieselben `JAN`…`DEC` wie der Gregorianische).
- Jahre folgen der **historischen** Zählung. Es gibt kein Jahr 0, und v. Chr. wird mit `BCE` angehängt (`44 BCE` = 44 v. Chr.). Gegenüber der astronomischen Zählung von EDTF und GREGORIAN-DATE gibt es einen Unterschied von einem Jahr.
- Das Schema prüft nur das Byteformat: ASCII `0x20`~`0x7E`, nicht leer, keine Leerzeichen am Anfang oder Ende. Grammatik und tatsächliche Existenz des Tages prüft der Erzeuger. Beispiel: `gedcom.ParseDate` von `github.com/cacack/gedcom-go/v3` (MIT). `Validate` dieser Bibliothek prüft Tage nur im gregorianischen Kalender und lässt `JULIAN 30 FEB 1100` durch, und `ToGregorian` wandelt Jahres- und Monatsgenauigkeit nicht tatsächlich um. Prüfung der Existenz des Datums und Normalisierung erfolgen gesondert.
- **Verwendung:** Gregorianische Daten schreibt man als [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) oder [EDTF](/de/grammar/value/time/edtf/). GEDCOM-DATE verwendet man für Daten anderer Kalender, deren Originalschreibweise bewahrt werden muss.

## Zusammen mit normalisiertem Wert

- Um dasselbe Datum auf der Zeitachse zu vergleichen und zu indizieren, braucht man einen gregorianischen Wert. Bei Tagesgenauigkeit ist das GREGORIAN-DATE desselben Tages, bei Jahres- und Monatsgenauigkeit das EDTF-Intervall dieses Zeitraums im gregorianischen Kalender (`JULIAN 1300` → `1300-01-09/1301-01-08`) die genaue Entsprechung.
- Wie man Originalschreibweise (GEDCOM-DATE) und normalisierten Wert zusammen als zwei Values ablegt, ist noch nicht festgelegt (offene Frage).

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload ([Length](/de/grammar/record/)).

## Beispiel

| Datum | Bytes | Gesamt-WORD |
|---|---|---|
| `JULIAN 1300` | 11 (ungerade) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Normgrundlage

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). Das Repository der Spezifikation steht unter Apache 2.0. GEUL verweist nur auf das Format und übernimmt den Text der Spezifikation nicht.
- ISO 8601, EDTF, XSD und die CLDR-Kalenderkennungen (`u-ca`) enthalten den Julianischen Kalender nicht. GEDCOM 7 ist ein offenes Austauschformat, das Kalenderpräfix, v. Chr., Genauigkeit und Qualifier in einer Grammatik behandelt.

## Offene Fragen

- Wie Originalschreibweise und normalisierter Wert zusammen geschrieben werden (wie beide in einem TRIPLE verbunden werden).
- Die Prüfung der GEDCOM-Grammatik im Schema.
- Genauigkeit auf Jahrhundert- und Jahrzehntebene. In GEDCOM gibt es dafür kein Format. Daten aus Wikidata, die sich nicht übertragen lassen, bleiben als Originaltext in UTF8-TEXT.

## Verwandte Seiten

- [Value](/de/grammar/value/), [EDTF](/de/grammar/value/time/edtf/), [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/)
