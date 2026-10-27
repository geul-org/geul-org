---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR ist ein eindimensionaler Vektor-Value, der Big-Endian-uint16-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0501)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR ist ein homogener eindimensionaler Value, der Big-Endian-uint16-Elemente ohne Descriptor aneinanderreiht.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0501`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## Interpretationsregeln

- Jedes WORD wird als eigenständige vorzeichenlose 16-Bit-Ganzzahl gelesen. Die Elementzahl ist die Zahl der Payload-WORD.
- Zwischen den Elementen und am Ende gibt es kein ABI-Padding.

## Gültigkeit

- Der Payload muss mindestens 1 WORD haben. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.
- Die Payload-Größe muss ein ganzzahliges Vielfaches der Elementbreite von 1 WORD sein.

## Normgrundlage und Formatstatus

- Die vorzeichenlose Interpretation und die 16-Bit-Breite des unsigned integer dtype richten sich nach dem Industrie-dtype von [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) und [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Die eindimensionale Folge ohne Descriptor sowie GEUL-TAG/Length und die Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da DLPack Native-Endian für das dtype annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `0000 ffff` ist das Element `[0, 65535]` und ein Record mit insgesamt 5 WORD und direkter Länge `LLLL=0100`.
