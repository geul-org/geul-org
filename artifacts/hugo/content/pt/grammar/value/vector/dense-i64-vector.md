---
title: "DENSE-I64-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I64-VECTOR é o Value de vetor unidimensional que contém elementos int64 big-endian em sequência, sem descriptor (formato 0x0504 do Issuer ADHOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I64-VECTOR é um Value homogêneo unidimensional que guarda em sequência, sem descriptor, elementos int64 big-endian.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0504`. Família NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0504
Payload: [int64 1st: 4 WORD] ... [int64 Nth: 4 WORD]
```

## Regras de interpretação

- Cada 4 WORD consecutivas, combinadas a partir da WORD superior, são lidas como um inteiro em complemento de dois de 64 bits.
- O número de elementos é um quarto do número de WORDs do Payload, e não há ABI padding.

## Validade

- O Payload deve ter 4 WORD ou mais e ser um múltiplo inteiro de 4 WORD. Este formato, que não tem descriptor, não admite vector vazio.

## Base normativa e status do formato

- A signedness do dtype signed integer e a largura de 64 bits ajustam-se ao dtype industrial do [tensor element type do ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) e do [`DLDataType` do DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- A interpretação em complemento de dois, a sequência contígua unidimensional sem descriptor, a TAG/Length do GEUL e a disposição de WORD big-endian são um formato próprio do GEUL. Como o DLPack pressupõe que o dtype é native-endian, este Payload não é a wire serialization do DLPack nem do ONNX.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).

## Exemplo

- O Payload `ffff ffff ffff ffff` é o elemento `[-1]`, num registro de 7 WORD no total.
