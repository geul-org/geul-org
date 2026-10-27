---
title: "DENSE-I64-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I64-VECTOR ist ein eindimensionaler Vektor-Value, der Big-Endian-int64-Elemente ohne Descriptor aneinanderreiht (ADHOC-Issuer-Format 0x0504)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I64-VECTOR ist ein homogener eindimensionaler Value, der Big-Endian-int64-Elemente ohne Descriptor aneinanderreiht.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0504`. Familie NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0504
Payload: [int64 1st: 4 WORD] ... [int64 Nth: 4 WORD]
```

## Interpretationsregeln

- Je vier aufeinanderfolgende WORD werden ab dem oberen WORD zu einer 64-Bit-Zweierkomplement-Ganzzahl verbunden.
- Die Elementzahl ist 1/4 der Zahl der Payload-WORD, und es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload hat mindestens 4 WORD und ist ein ganzzahliges Vielfaches von 4 WORD. Dieses Format ohne Descriptor lässt keine leeren Vektoren zu.

## Normgrundlage und Formatstatus

- Signedness und 64-Bit-Breite des signed integer dtype richten sich nach dem Industrie-dtype von [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) und [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Die Zweierkomplement-Interpretation, die eindimensionale Folge ohne Descriptor sowie GEUL-TAG/Length und die Big-Endian-WORD-Anordnung sind ein GEUL-eigenes Format. Da DLPack Native-Endian für das dtype annimmt, ist dieser Payload keine Wire-Serialisierung von DLPack oder ONNX.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- Der Payload `ffff ffff ffff ffff` ist das Element `[-1]` und ein Record mit insgesamt 7 WORD.
