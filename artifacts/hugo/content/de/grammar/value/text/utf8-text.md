---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT ist ein Value, der eine UTF-8-Zeichenkette ohne Sprache enthält. Es wird das Codepaar 0x40/0x41 für gerade/ungerade Bytezahl verwendet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT ist ein Value, der eine gültige UTF-8-Bytefolge nach RFC 3629 enthält. Er wird für Zeichenketten ohne Sprache wie Kennungen, Codes und Dateinamen verwendet.

## Layout

- Code: direkter Value-Code `0x40` (gerade Bytezahl) und `0x41` (ungerade Bytezahl). Familie TEXT.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit des Codec und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretation und Gültigkeit

- Die Bytefolge muss wohlgeformtes UTF-8 in kürzester Form (shortest-form) nach der Grammatik von RFC 3629 sein. Das Dekodierungsergebnis enthält nur Unicode-Skalarwerte im Bereich `U+0000..U+10FFFF` und nicht den Surrogatbereich `U+D800..U+DFFF`.
- RFC 3629 beschreibt die kontextabhängige Behandlung einer führenden U+FEFF-Signatur. Das kanonische GEUL-Profil verbietet darüber hinaus die UTF-8-BOM-Bytefolge `EF BB BF` am Anfang des Payloads. Ein U+FEFF an anderer Stelle ist keine BOM, sondern ein Zeichen, und wird von dieser Regel nicht verboten.
- Eine Unicode-Normalisierung wird nicht erzwungen. Die dekodierte Skalarsequenz des Originals bleibt unverändert erhalten.
- Eine gültige UTF-8-Bytefolge wird ohne Umwandlung im Payload abgelegt. Innerhalb eines WORD steht das obere Byte zuerst. Bei ungerader Bytezahl (ungerader Code) muss das nicht verwendete untere Byte des letzten WORD `00` sein.
- Die Zahl der Payload-WORD ist `ceil(Bytezahl/2)`. Ist es ein ungerader Code und das untere Byte des letzten WORD nicht `00`, wird abgelehnt.

## Normgrundlage

- Skalarbereich, wohlgeformte Bytefolge und die Bedeutung der BOM-Behandlung von UTF-8 richten sich nach [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- BOM-Verbot, Codepaar aus gerade/ungerade, Zero-Padding sowie GEUL-TAG/Length und die 16-Bit-WORD-Anordnung sind kanonische Framing-Regeln dieses Formats.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).
- Eine Zeichenkette mit 0 Byte wird als 1-WORD-Record (nur TAG WORD) des geraden Codec geschrieben ([Value](/de/grammar/value/)).

## Beispiel

- `A` (`41`) hat 1 Byte (ungerade), also `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, insgesamt 2 WORD, `LLLL=0001`. Der gesamte Record ist `08C1 4100`.
- Die leere Zeichenkette ist `0840` (`UTF8-TEXT-EVEN`, nur TAG WORD), also 1 WORD.
