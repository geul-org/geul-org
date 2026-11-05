---
title: "DENSE-BINARY32-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR legt IEEE-754-binary32-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR legt IEEE-754-binary32-Interchange-Bitmuster ohne Descriptor aneinandergereiht ab.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000508`. Familie NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Je 2 aufeinanderfolgende WORD bilden ein Element und werden ab dem höchstwertigen WORD gelesen. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Die Elementzahl ist 1/2 der Zahl der Payload-WORD, und es gibt kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload muss mindestens 2 WORD umfassen und ein ganzzahliges Vielfaches von 2 WORD sein. Dieses Format ohne Descriptor lässt keinen leeren Vektor zu.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Das Interchange-Format der binary32-Elemente folgt [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Die eindimensionale zusammenhängende Folge ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](../../record.md)).

## Beispiel {#예시}

- Der Payload `3F80 0000 8000 0000` ist binary32 `[1.0, -0]` und ein Record mit insgesamt 9 WORD.
