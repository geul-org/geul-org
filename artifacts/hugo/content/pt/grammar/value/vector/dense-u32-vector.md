---
title: "DENSE-U32-VECTOR"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U32-VECTOR é o Value de vetor unidimensional que contém elementos uint32 big-endian em sequência, sem descriptor (formato 0x0503 do Issuer ADHOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U32-VECTOR é um Value homogêneo unidimensional que guarda em sequência, sem descriptor, elementos uint32 big-endian.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0503`. Família NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0503
Payload: [uint32 1st: 2 WORD] ... [uint32 Nth: 2 WORD]
```

## Regras de interpretação

- Cada 2 WORD consecutivas, combinadas a partir da WORD superior, são lidas como um inteiro unsigned de 32 bits.
- O número de elementos é metade do número de WORDs do Payload, e não há ABI padding.

## Validade

- O Payload deve ter 2 WORD ou mais e ser um múltiplo inteiro de 2 WORD. Este formato, que não tem descriptor, não admite vector vazio.

## Base normativa e status do formato

- A signedness do dtype unsigned integer e a largura de 32 bits ajustam-se ao dtype industrial do [tensor element type do ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) e do [`DLDataType` do DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- A sequência contígua unidimensional sem descriptor, a TAG/Length do GEUL e a disposição de WORD big-endian são um formato próprio do GEUL. Como o DLPack pressupõe que o dtype é native-endian, este Payload não é a wire serialization do DLPack nem do ONNX.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).

## Exemplo

- O Payload `0000 0000 ffff ffff` são os elementos `[0, 4294967295]`, num registro de 7 WORD no total.
