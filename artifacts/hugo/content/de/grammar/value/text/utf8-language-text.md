---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT ist Text mit Sprache, der einen Sprach-Value-Record und UTF-8-Text in einem Value enthält (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT ist Text mit Sprache. Er enthält einen Sprach-Value-Record und eine UTF-8-Bytefolge in einem Value.

[UTF8-TEXT](/de/grammar/value/text/utf8-text/) ist eine Zeichenkette ohne Sprache (Kennung, Code, Dateiname, Original-Bytes), dieses Format ist Text mit Sprache (Name, Titel, Motto, Satz). Beide sind auch bei gleichen Bytes verschiedene Werte. „Paris“ (Zeichenkette) und „Paris“ (Französisch) sind nicht gleich. Das entspricht der Unterscheidung von `xsd:string` und `rdf:langString` in RDF.

## Layout

- Code: direkter Value-Code `0x4A` (Text mit gerader Bytezahl) und `0x4B` (Text mit ungerader Bytezahl). Familie TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = Text hat ungerade Bytezahl)
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Language          1 LANGUAGE-SHORT-CODE- oder LANGUAGE-BCP47-CODE-Value-Record (einschließlich TAG)
Text WORD 1st ... Nth             UTF-8 bytes / bei ungerader Zahl zuletzt 0x00
```

## Interpretation und Gültigkeit

- Der Payload beginnt mit dem Sprach-Record. Das erste WORD des Payloads wird als TAG gelesen, dessen Length ist der Sprach-Record, und der Rest sind die Textbytes. Der Sprach-Record ist Pflicht. Gibt es keine Sprache, verwendet man nicht dieses Format, sondern UTF8-TEXT.
- Der Sprach-Record ist genau ein vollständiger [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/)- (`0x48`) oder [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/)- (`0x46`/`0x47`) Record. Bei einem anderen Codec oder unvollständig ist es invalid. Die Gültigkeit des Sprach-Records folgt den Regeln dieses Formats.
- Beide Sprachformate sind zulässig. Die Regel zum Vergleich, ob es dieselbe Sprache ist, ist wie bei [LABEL](/de/grammar/edge/label/). Ein SHORT-CODE und der BCP-47-Tag, den die Registry an seine Nummer bindet, sind dieselbe Sprache.
- `zxx` (kein Sprachinhalt) wird nicht verwendet. Eine solche Zeichenkette ist UTF8-TEXT. `und` (Sprache unbestimmt) und `mul` (mehrere Sprachen) sind Text mit Sprache und können verwendet werden.
- Die Textbytes folgen denselben Regeln wie UTF8-TEXT. Sie müssen wohlgeformtes UTF-8 sein, eine führende BOM ist verboten, eine Normalisierung wird nicht erzwungen und der Originaltext bleibt unverändert erhalten. Wer vergleicht oder indiziert, gleicht auf NFC ab.
- Die Textbytezahl ist `2 × (Anzahl der Payload-WORD − WORD-Zahl des Sprach-Records) − P`. P (niederwertigstes Bit des Codec) gibt nur die Parität der Textbytes an. Bei ungerader Zahl muss das untere Byte des letzten WORD `00` sein.
- Ein leerer Text (0 Byte) besteht bei geradem Codec nur aus dem Sprach-Record.

## Verwendung

- Monolingualtext-Werte in Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` wird zu diesem einen Format. Er geht unverändert in das Object eines [TRIPLE](/de/grammar/edge/triple/) und den Value eines [QUALIFIER](/de/grammar/edge/qualifier/). Eigenschaft, rank und qualifier übernimmt das TRIPLE.
- Das Object von [LABEL](/de/grammar/edge/label/) und [ALIAS](/de/grammar/edge/alias/). Name und Sprache enthält dieser eine Wert.
- Text mit festgelegter Sprache wie Titel von Gesetzen und Aufsätzen.

## Zuordnung der Sprachcodes (Wikidata)

- Nicht alle Sprachcodes von Wikidata und Wikimedia sind BCP 47 (z. B. `simple`, `map-bms`). Sie werden über eine Zuordnungstabelle in BCP-47-Tags übertragen. Codes, die sich nicht übertragen lassen, werden je nach Verwendung unterschiedlich behandelt.
  - Wert (monolingualtext): Der Originaltext des datavalue wird als UTF8-TEXT bewahrt. Ein Wert ist Teil der Proposition, und wirft man ihn weg, ändert sich die Proposition.
  - Label, Beschreibung, Alias: Sie werden übersprungen und im Bericht festgehalten. Diese Edges bestehen nur mit Sprache (Text ohne Sprache ist invalid), und der Originaltext bleibt in den Ausgangsdaten erhalten.
- Hat der zugeordnete Tag eine Nummer in der GEUL Language Registry, wird LANGUAGE-SHORT-CODE verwendet, sonst LANGUAGE-BCP47-CODE.

## Länge

- Insgesamt ist es die Summe aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), Sprach-Record und Text-WORD. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge ([Length](/de/grammar/record/)).
- Der Sprach-Record hat bei SHORT-CODE 2 WORD, bei BCP 47 `ceil(Tag-Bytes/2) + 1` WORD (`de` 2 WORD, `zh-Hant` 5 WORD).

## Beispiel

Die Sprachen sind hier alle Beispiele für das Format LANGUAGE-BCP47-CODE. `fr`, `ko` und `de` haben Registry-Nummern und können daher auch als SHORT-CODE (2 WORD) geschrieben werden.

| Wert | Textbytes | Gesamt-WORD |
|---|---|---|
| "Paris" (fr) | 5 (ungerade) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (gerade) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- „Paris“: TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, insgesamt 6 WORD), Sprache `08C6 6672` (BCP 47 `fr`), Text `5061 7269 7300` (5 Byte, zuletzt `00`).
- Das dritte hat insgesamt 17 WORD und verwendet daher die Length-Erweiterung (`LLLL=1110` von `0F4A`, Erweiterungs-TAG `0011`).

## Normgrundlage

- Language-Tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` und `mul` sind Spezialcodes der IANA Language Subtag Registry.
- Text: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Unterscheidung von Zeichenkette und Text mit Sprache: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Offene Fragen

- Die Prüfung der BCP-47-Tag-Grammatik im Schema. Derzeit wird nur geprüft, dass es ASCII und nicht leer ist.

## Verwandte Seiten

- [Value](/de/grammar/value/), [UTF8-TEXT](/de/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/), [LABEL](/de/grammar/edge/label/)
