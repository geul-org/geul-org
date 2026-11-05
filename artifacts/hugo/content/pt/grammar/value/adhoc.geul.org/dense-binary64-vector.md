---
title: "DENSE-BINARY64-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR armazena em sequência os interchange bit patterns IEEE 754 binary64, sem descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR armazena em sequência os interchange bit patterns IEEE 754 binary64, sem descriptor.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000509`. Família NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG estendida de Length] quando o total for de 15 WORD ou mais
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Regras de interpretação {#해석-규칙}

- 4 WORD consecutivos formam um elemento, lido a partir do WORD mais significativo. O bit pattern, incluindo o NaN payload e o zero com sinal, é preservado como está.
- O número de elementos é 1/4 do número de WORD do Payload, e não há ABI padding.

## Validade {#유효성}

- O Payload deve ter 4 WORD ou mais e ser múltiplo inteiro de 4 WORD. Sem descriptor, este formato não admite vector vazio.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O interchange format dos elementos binary64 segue o [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- A sequência contígua unidimensional sem descriptor, a TAG/Length do GEUL e a disposição em WORD big-endian de 16 bits são um formato próprio do GEUL. O [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) pressupõe native-endian; portanto, este Payload não é a wire serialization de DLPack, Arrow nem ONNX.

## Comprimento {#길이}

- O total é o número de WORD somando TAG 1 WORD, a TAG estendida de Length (se houver), Issuer 2 WORD, número do Codec 2 WORD e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e a TAG estendida também conta no total ([Length](../../record.md)).

## Exemplo {#예시}

- O Payload `3FF0 0000 0000 0000` é binary64 `[1.0]`, num registro de 9 WORD no total.
