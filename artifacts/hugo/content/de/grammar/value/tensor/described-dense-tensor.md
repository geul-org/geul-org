---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR ist ein ADHOC-Issuer-Format, das nach einem Descriptor aus element format, rank und shape Elemente C-contiguous in Row-Major-Reihenfolge enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR ist ein Tensor-Value, der shape und element format im Payload-Descriptor angibt und einen C-contiguous Row-Major-Payload speichert. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0600`, Familie NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload Rest      [dense payload]
```

## Interpretation

- Da rank ein 4-Bit-Wert des Descriptors ist, lässt sich strukturell nur `0..15` darstellen. Jede dimension ist eine nicht negative Big-Endian-uint32.
- Wie bei den logischen Tensorregeln von ONNX ist der rank-0-shape `[]` ein Skalar mit einem Element, und ist auch nur eine dimension 0, ist die Elementzahl 0. Sonst ist die Elementzahl das Produkt aller dimensions.
- Der Payload wird mit dem element format des Descriptors gelesen und liegt in C-contiguous Row-Major-Reihenfolge. Die berechnete logische Elementzahl muss der Elementzahl des Payloads nach dem Descriptor entsprechen.

## Gültigkeit

- Sobald unterstützte version und element format feststehen, stellt man mit deren Elementbreite die Payload-Grenze wieder her und prüft, ob sie zum ohne overflow berechneten Produkt des shape passt.
- Descriptor, alle dimensions und Payload müssen vollständig in die Length des Records passen, und es gibt kein beliebiges ABI-Padding.

## Normgrundlage und Formatstatus

- Die Regel, dass shape eine Liste nicht negativer dimensions ist und die Wertezahl dem Produkt der dimensions entspricht, sowie die Bedeutung von rank-0-Skalar und Null-dimension richten sich nach der [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Die logische C-contiguous Row-Major-Reihenfolge entspricht der Reihenfolge der [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- 4-Bit-rank, uint32-dimension, die Felder version/element-format, GEUL-TAG/Length und der Big-Endian-WORD-Payload sind ein GEUL-eigener Descriptor. Es ist keine Wire-/Memory-Serialisierung des [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), von ONNX TensorProto oder der [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- Der Descriptor hat 1 WORD, der shape `2 × rank` WORD, und der Rest ist der Payload.

## Beispiel

- Bei einem Profil mit rank 2 sind die 4 WORD nach dem Descriptor zwei uint32-dimensions, und danach folgt der gesamte Row-Major-Payload. Für die tatsächliche Zulässigkeit und die Prüfung der Elementzahl braucht man ein festgelegtes version-/format-Profil.

## Offene Fragen

- Die Werte der Register für version und element-format sowie der Bereich der zu unterstützenden Profile unter den darstellbaren rank `0..15` sind noch nicht festgelegt.
