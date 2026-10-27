---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR ist ein eindimensionaler Vektor-Value, der binary64-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0509)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR legt IEEE-754-binary64-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0509`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Interpretationsregeln

- Je vier aufeinanderfolgende WORD sind ein Element und werden ab dem oberen WORD gelesen. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Die Elementzahl ist 1/4 der Zahl der Payload-WORD, und es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload hat mindestens 4 WORD und ist ein ganzzahliges Vielfaches von 4 WORD. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.

## Normgrundlage und Formatstatus

- Das Interchange-Format der binary64-Elemente richtet sich nach [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Die eindimensionale Folge ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `3ff0 0000 0000 0000` ist binary64 `[1.0]` und ein Record mit insgesamt 7 WORD.
