---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR ist ein Tensor-Value, der Shape und Element Format im Payload-Descriptor angibt und den Payload C-contiguous in Row-Major-Ordnung ablegt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR ist ein Tensor-Value, der Shape und Element Format im Payload-Descriptor angibt und den Payload C-contiguous in Row-Major-Ordnung ablegt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000600`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload Rest      [dense payload]
```

## Interpretation {#해석}

- Der rank ist ein 4-Bit-Wert des Descriptors und kann strukturell nur `0..15` ausdrücken. Jede dimension ist ein nichtnegatives Big-Endian-uint32.
- Wie in den logischen Tensor-Regeln von ONNX ist ein Shape `[]` mit rank 0 ein Scalar mit einem Element, und ist eine beliebige dimension 0, ist die Elementzahl 0. Sonst ist die Elementzahl das Produkt aller dimensions.
- Der Payload wird im Element Format des Descriptors gelesen, in C-contiguous Row-Major-Reihenfolge. Die berechnete logische Elementzahl muss der Elementzahl des Payloads nach dem Descriptor entsprechen.

## Gültigkeit {#유효성}

- Sobald die unterstützten version und das Element Format feststehen, wird anhand von deren Elementbreite die Grenze des Payloads wiederhergestellt und geprüft, ob sie mit dem ohne Überlauf berechneten Shape-Produkt übereinstimmt.
- Descriptor, alle dimensions und Payload müssen vollständig innerhalb der Record-Length liegen; beliebiges ABI-Padding gibt es nicht.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die Regel, dass der Shape eine Liste nichtnegativer dimensions ist und die Wertezahl dem Produkt der dimensions entspricht, sowie die Bedeutung von rank-0-Scalar und zero dimension folgen der [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Die logische C-contiguous Row-Major-Reihenfolge entspricht der des [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- 4-Bit-rank, uint32-dimension, version-/element-format-Felder, GEUL-TAG/Length und der Big-Endian-WORD-Payload sind ein GEUL-eigener Descriptor. Es ist keine Wire- oder Memory-Serialisierung des [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), von ONNX TensorProto oder der [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](../../record.md)).
- Der Descriptor umfasst 1 WORD, der Shape `2 × rank` WORD, der Rest ist der Payload.

## Beispiel {#예시}

- Bei einem Profil mit rank 2 sind die 4 WORD nach dem Descriptor die beiden uint32-dimensions, und alles danach ist der Row-Major-Payload. Ob dies tatsächlich zulässig ist und wie die Elementzahl geprüft wird, erfordert ein festgelegtes version-/format-Profil.

## Offene Probleme {#열린-문제}

- Die Werte der version- und element-format-Registry sowie der Umfang der unterstützten Profile innerhalb der darstellbaren rank `0..15` sind noch nicht festgelegt.
