---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR ist ein ADHOC-Issuer-Format, das nach einem Descriptor aus packed format, rank und shape Sub-WORD-Elemente low-bit-first gefüllt enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR ist ein Tensor-Value, der shape und packed format im Payload-Descriptor angibt und Elemente, die kleiner als ein WORD sind, gepackt speichert. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0601`, Familie NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload Rest      [packed payload octet stream, low-bit-first]
```

## Interpretation

- Da rank ein 4-Bit-Wert des Descriptors ist, lässt sich strukturell nur `0..15` darstellen. Jede dimension ist eine nicht negative Big-Endian-uint32. Die logische Reihenfolge ist C-contiguous Row-Major.
- Wie bei den logischen Tensorregeln von ONNX ist der rank-0-shape `[]` ein Skalar mit einem Element, und ist auch nur eine dimension 0, ist die Elementzahl 0. Sonst ist die Elementzahl das Produkt aller dimensions.
- Das packed-format legt Elementkodierung und Bitbreite fest, etwa bei int2/int4, FP4/FP6 und bestimmten FP8-Varianten.
- Nennt man die Oktettfolge des Payloads `p[0], p[1], ...` und betrachtet sie als little-bit-endian-Ganzzahl `P = Σ(p[j] << (8j))`, ist das logische Element `i` der Breite `w` gleich `(P >> (i × w)) & ((1 << w) - 1)`. Das heißt, vom ersten Element an wird in die niedrigsten Bits gelegt.
- In den WORD wird `p[0]` als oberes Oktett des ersten WORD, `p[1]` als unteres Oktett usw. abgelegt. Die nicht verwendeten oberen tail bits des letzten verwendeten Oktetts müssen 0 sein, und ist die Zahl der Payload-Oktette ungerade, muss das gesamte nicht verwendete untere Oktett des letzten WORD `00` sein.

## Gültigkeit

- Bei Anwendung der Bitbreite des unterstützten Formats muss die Elementzahl des Payloads zum ohne overflow berechneten Produkt der dimensions des shape passen.
- Ist hinter den benötigten Payload-Bits irgendein high tail bit oder Oktett-Padding 1, wird abgelehnt. Descriptor, shape und Payload müssen vollständig in die Length des Records passen.

## Normgrundlage und Formatstatus

- Die logische Bedeutung von shape, rank-0-Skalar und Null-dimension richtet sich nach der [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Die Regel, Sub-Byte-Elemente ab den niedrigen Bits abzulegen, folgt dem int2/int4-Packing des offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) und dem little bit-endian Packing von [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- 4-Bit-rank, uint32-dimension, die Felder version/packed-format, die Bündelung von Oktetten zu Big-Endian-WORD und GEUL-TAG/Length sind ein GEUL-eigener Descriptor. Es ist keine Wire-/Memory-Serialisierung von ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) oder DLPack selbst.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- Der Descriptor hat 1 WORD, der shape `2 × rank` WORD, und der Rest ist der gepackte Payload.
- Ist die logische Elementzahl `N` und die Elementbreite `w`, beträgt die Zahl der Payload-Oktette `ceil(N × w / 8)` und die Zahl der Payload-WORD `ceil(Zahl der Payload-Oktette / 2)`.

## Beispiel

- Bei einem Profil mit rank 2 sind die 4 WORD nach dem Descriptor der shape, und danach folgt die low-bit-first-Payload-Oktettfolge. Elementbreite und tatsächliche Zulässigkeit werden anhand des festgelegten format-Profils beurteilt.
- Die Payload-Oktettfolge der 4-Bit-Elemente `[1, 2, 3]` ist `21 03`, und das Payload-WORD ist `2103`. Das erste Element liegt im niedrigen Nibble des ersten Oktetts, und das nicht verwendete hohe Nibble des letzten Oktetts ist 0.

## Offene Fragen

- Die Werte der Register für version und packed-format sowie der Bereich der zu unterstützenden Profile unter den darstellbaren rank `0..15` sind noch nicht festgelegt.
