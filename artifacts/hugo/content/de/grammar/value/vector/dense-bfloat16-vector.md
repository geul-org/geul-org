---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR ist ein eindimensionaler Vektor-Value, der BF16-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0507)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR legt die 16-Bit-Bitmuster von bfloat16-Elementen ohne Descriptor aneinandergereiht ab. Es ist ein anderes Format als binary16.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0507`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Interpretationsregeln

- Die Elementzahl ist die Zahl der Payload-WORD. Das Bitmuster einschließlich NaN-Payload und signed zero bleibt unverändert erhalten.
- Zwischen den Elementen und am Ende gibt es kein ABI-Padding.

## Gültigkeit

- Der Payload muss mindestens 1 WORD haben. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.
- Die Payload-Größe muss ein ganzzahliges Vielfaches der Elementbreite von 1 WORD sein.

## Normgrundlage und Formatstatus

- Das eigene 16-Bit-dtype bfloat16 und die Unterscheidung von binary16 richten sich nach [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) und [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Die eindimensionale Folge von Bitmustern ohne Descriptor sowie GEUL-TAG/Length und die 16-Bit-Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da DLPack Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack, Arrow oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `3f80 8000` ist BF16 `1.0` und `-0` und ein Record mit insgesamt 5 WORD.
