---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR ist ein eindimensionaler Vektor-Value, der binary16-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0506)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR legt IEEE-754-binary16-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0506`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Interpretationsregeln

- Die Elementzahl ist die Zahl der Payload-WORD. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Zwischen den Elementen und am Ende gibt es kein ABI-Padding.

## Gültigkeit

- Der Payload muss mindestens 1 WORD haben. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.
- Die Payload-Größe muss ein ganzzahliges Vielfaches der Elementbreite von 1 WORD sein.

## Normgrundlage und Formatstatus

- Das Interchange-Format der binary16-Elemente richtet sich nach [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Die eindimensionale Folge ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `3c00 8000` ist binary16 `1.0` und `-0` und ein Record mit insgesamt 5 WORD.
