---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES ist ein GEUL-Issuer-Format, das eine beliebige Bytefolge enthält, deren Bedeutung und Format es nicht selbst festlegt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES ist eine beliebige Bytefolge, deren Bedeutung und Format dieses Format selbst nicht festlegt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, Formatnummer `0xC000`/`0xC001` (gerade/ungerade Bytezahl), Familie BINARY. Die Bytezahl ergibt sich aus dem niederwertigsten Bit der Formatnummer und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0000 (GEUL)
Formatnummer      1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   Bytes / zuletzt Zero-Padding
```

## Interpretation und Gültigkeit

- Aus dem Payload werden so viele Bytes der Reihe nach gelesen, wie die Bytezahl angibt. Innerhalb eines WORD steht das obere Byte zuerst.
- Die Zahl der Payload-WORD ist `ceil(Bytezahl/2)`. Ist es ein ungerader Code und das untere Byte des letzten WORD nicht `00`, wird abgelehnt.
- Passen gerader/ungerader Code, Zahl der Payload-WORD und Zero-Padding nicht zusammen, wird abgelehnt.

## Formatstatus

- Codepaar aus gerade/ungerade, Payload-Anordnung und Zero-Padding im letzten WORD sind kein Zitat eines externen Industriestandards, sondern GEUL-eigenes Framing.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- 0 Byte werden mit der geraden Formatnummer (`0xC000`) als Record mit 3 WORD ohne Payload (TAG, Issuer, Formatnummer) geschrieben.

## Beispiel

Die Bytes `ab cd ef` haben 3 Byte (ungerade), also die Formatnummer `0xC001`, Payload `abcd ef00`. Insgesamt sind es 5 WORD, also `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
