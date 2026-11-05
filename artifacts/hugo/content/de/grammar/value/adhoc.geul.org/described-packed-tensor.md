---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR ist ein Tensor-Value, der Shape und Packed Format im Payload-Descriptor angibt und Elemente, die kleiner als ein WORD sind, gepackt ablegt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR ist ein Tensor-Value, der Shape und Packed Format im Payload-Descriptor angibt und Elemente, die kleiner als ein WORD sind, gepackt ablegt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000601`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload Rest      [packed payload octet stream, low-bit-first]
```

## Interpretation {#해석}

- Der rank ist ein 4-Bit-Wert des Descriptors und kann strukturell nur `0..15` ausdrücken. Jede dimension ist ein nichtnegatives Big-Endian-uint32. Die logische Reihenfolge ist C-contiguous Row-Major.
- Wie in den logischen Tensor-Regeln von ONNX ist ein Shape `[]` mit rank 0 ein Scalar mit einem Element, und ist eine beliebige dimension 0, ist die Elementzahl 0. Sonst ist die Elementzahl das Produkt aller dimensions.
- Das packed-format legt Element-Encoding und Bitbreite fest, etwa bei int2/int4, FP4/FP6 oder bestimmten FP8-Varianten.
- Nennt man die Payload-Octet-Folge `p[0], p[1], ...` und betrachtet sie als little-bit-endian Ganzzahl `P = Σ(p[j] << (8j))`, so ist das logische Element `i` mit Breite `w` gleich `(P >> (i × w)) & ((1 << w) - 1)`. Das erste Element wird also in die niedrigsten Bits gelegt.
- In den WORD wird `p[0]` als oberstes Octet des ersten WORD abgelegt, danach `p[1]` als unteres Octet usw. Die ungenutzten oberen Tail-Bits des letzten verwendeten Octets müssen 0 sein, und ist die Zahl der Payload-Octets ungerade, muss das gesamte ungenutzte untere Octet des letzten WORD `00` sein.

## Gültigkeit {#유효성}

- Das ohne Überlauf berechnete Produkt der Shape-dimensions muss bei Anwendung der Bitbreite des unterstützten Formats mit der Elementzahl des Payloads übereinstimmen.
- Ist auch nur ein High-Tail-Bit oder Octet-Padding hinter den benötigten Payload-Bits 1, wird der Wert abgelehnt. Descriptor, Shape und Payload müssen vollständig innerhalb der Record-Length liegen.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die logische Bedeutung von Shape, rank-0-Scalar und zero dimension folgt der [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Die Regel, Sub-Byte-Elemente ab den niedrigen Bits abzulegen, folgt dem int2/int4-Packing des offiziellen [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) und dem Little-Bit-Endian-Packing von [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- 4-Bit-rank, uint32-dimension, version-/packed-format-Felder, die Bündelung der Octets zu Big-Endian-WORD und GEUL-TAG/Length sind ein GEUL-eigener Descriptor. Es ist keine Wire- oder Memory-Serialisierung von ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) oder DLPack selbst.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](../../record.md)).
- Der Descriptor umfasst 1 WORD, der Shape `2 × rank` WORD, der Rest ist der Packed Payload.
- Bei `N` logischen Elementen und Elementbreite `w` beträgt die Zahl der Payload-Octets `ceil(N × w / 8)` und die Zahl der Payload-WORD `ceil(Zahl der Payload-Octets / 2)`.

## Beispiel {#예시}

- Bei einem Profil mit rank 2 bilden die 4 WORD nach dem Descriptor den Shape, danach folgt die Low-Bit-First-Payload-Octet-Folge. Elementbreite und tatsächliche Zulässigkeit werden anhand des festgelegten Format-Profils beurteilt.
- Für die 4-Bit-Elemente `[1, 2, 3]` lautet die Payload-Octet-Folge `21 03` und das Payload-WORD `2103`. Das erste Element liegt im niedrigen Nibble des ersten Octets, und das ungenutzte hohe Nibble des letzten Octets ist 0.

## Offene Probleme {#열린-문제}

- Die Werte der version- und packed-format-Registry sowie der Umfang der unterstützten Profile innerhalb der darstellbaren rank `0..15` sind noch nicht festgelegt.
