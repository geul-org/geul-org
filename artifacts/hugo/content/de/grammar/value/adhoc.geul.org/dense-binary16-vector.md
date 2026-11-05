---
title: "DENSE-BINARY16-VECTOR"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR legt IEEE-754-binary16-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR legt IEEE-754-binary16-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000506`. Familie NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Die Elementzahl ist die Zahl der Payload-WORD. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Zwischen den Elementen und am Ende gibt es kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload muss mindestens 1 WORD umfassen. Dieses Format ohne Descriptor lässt keinen leeren Vektor zu.
- Die Payload-Größe muss ein ganzzahliges Vielfaches der Elementbreite von 1 WORD sein.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Das Interchange-Format der binary16-Elemente folgt [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Die eindimensionale zusammenhängende Folge ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](../../record.md)).

## Beispiel {#예시}

- Der Payload `3C00 8000` ist binary16 `1.0` und `-0` und ein Record mit insgesamt 7 WORD.
