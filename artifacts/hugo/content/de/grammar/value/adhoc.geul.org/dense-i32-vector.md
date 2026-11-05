---
title: "DENSE-I32-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I32-VECTOR ist ein homogener eindimensionaler Value, der int32-Elemente im Big-Endian-Format ohne Descriptor aneinanderreiht."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I32-VECTOR ist ein homogener eindimensionaler Value, der int32-Elemente im Big-Endian-Format ohne Descriptor aneinanderreiht.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000502`. Familie NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000502
Payload: [int32 1st: 2 WORD] ... [int32 Nth: 2 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Je 2 aufeinanderfolgende WORD werden ab dem höchstwertigen WORD zusammengesetzt und als 32-Bit-Ganzzahl im Zweierkomplement gelesen.
- Die Elementzahl ist 1/2 der Zahl der Payload-WORD, und es gibt kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload muss mindestens 2 WORD umfassen und ein ganzzahliges Vielfaches von 2 WORD sein. Dieses Format ohne Descriptor lässt keinen leeren Vektor zu.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Vorzeichenbehaftung und 32-Bit-Breite des signed-integer-dtype richten sich nach den Industrie-dtypes des [ONNX-IR-Tensor-Elementtyps](https://onnx.ai/onnx/repo-docs/IR.html) und von [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Die Zweierkomplement-Interpretation, die eindimensionale zusammenhängende Folge ohne Descriptor sowie GEUL-TAG/Length und die Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da DLPack für dtypes Native-Endian annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack oder ONNX.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](../../record.md)).

## Beispiel {#예시}

- Der Payload `FFFF FFFF 0000 0002` ergibt die Elemente `[-1, 2]` und ist ein Record mit insgesamt 9 WORD.
