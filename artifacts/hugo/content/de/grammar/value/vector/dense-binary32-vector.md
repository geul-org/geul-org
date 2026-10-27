---
title: "DENSE-BINARY32-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR ist ein eindimensionaler Vektor-Value, der binary32-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0508)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR legt IEEE-754-binary32-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0508`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## Interpretationsregeln

- Je zwei aufeinanderfolgende WORD sind ein Element und werden ab dem oberen WORD gelesen. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Die Elementzahl ist 1/2 der Zahl der Payload-WORD, und es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload hat mindestens 2 WORD und ist ein ganzzahliges Vielfaches von 2 WORD. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.

## Normgrundlage und Formatstatus

- Das Interchange-Format der binary32-Elemente richtet sich nach [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Die eindimensionale Folge ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `3f80 0000 8000 0000` ist binary32 `[1.0, -0]` und ein Record mit insgesamt 7 WORD.
