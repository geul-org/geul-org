---
title: "DENSE-I32-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I32-VECTOR é um Value unidimensional homogêneo que armazena em sequência elementos int32 big-endian, sem descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I32-VECTOR é um Value unidimensional homogêneo que armazena em sequência elementos int32 big-endian, sem descriptor.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000502`. Família NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG estendida de Length] quando o total for de 15 WORD ou mais
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000502
Payload: [int32 1st: 2 WORD] ... [int32 Nth: 2 WORD]
```

## Regras de interpretação {#해석-규칙}

- 2 WORD consecutivos são combinados a partir do WORD mais significativo e lidos como um inteiro de 32 bits em complemento de dois.
- O número de elementos é 1/2 do número de WORD do Payload, e não há ABI padding.

## Validade {#유효성}

- O Payload deve ter 2 WORD ou mais e ser múltiplo inteiro de 2 WORD. Sem descriptor, este formato não admite vector vazio.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A signedness e a largura de 32 bits do dtype inteiro com sinal seguem os dtypes do setor: o [tipo de elemento de tensor do ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) e o [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- A interpretação em complemento de dois, a sequência contígua unidimensional sem descriptor, a TAG/Length do GEUL e a disposição em WORD big-endian são um formato próprio do GEUL. O DLPack pressupõe dtype em native-endian; portanto, este Payload não é a wire serialization de DLPack nem de ONNX.

## Comprimento {#길이}

- O total é o número de WORD somando TAG 1 WORD, a TAG estendida de Length (se houver), Issuer 2 WORD, número do Codec 2 WORD e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e a TAG estendida também conta no total ([Length](../../record.md)).

## Exemplo {#예시}

- O Payload `FFFF FFFF 0000 0002` é o conjunto de elementos `[-1, 2]`, num registro de 9 WORD no total.
