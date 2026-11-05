---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR legt die 16-Bit-Bitmuster von bfloat16-Elementen ohne Descriptor aneinandergereiht ab."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR legt die 16-Bit-Bitmuster von bfloat16-Elementen ohne Descriptor aneinandergereiht ab. Es ist ein anderes Format als binary16.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000507`. Familie NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Die Elementzahl ist die Zahl der Payload-WORD. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Zwischen den Elementen und am Ende gibt es kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload muss mindestens 1 WORD umfassen. Dieses Format ohne Descriptor lässt keinen leeren Vektor zu.
- Die Payload-Größe muss ein ganzzahliges Vielfaches der Elementbreite von 1 WORD sein.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Das eigene 16-Bit-dtype bfloat16 und die Unterscheidung von binary16 richten sich nach dem [ONNX-IR-Tensor-Elementtyp](https://onnx.ai/onnx/repo-docs/IR.html) und [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Die eindimensionale Folge von Bitmustern ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da DLPack Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](../../record.md)).

## Beispiel {#예시}

- Der Payload `3F80 8000` ist BF16 `1.0` und `-0` und ein Record mit insgesamt 7 WORD.
