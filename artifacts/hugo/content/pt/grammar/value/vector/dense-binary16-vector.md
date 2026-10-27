---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR é o Value de vetor unidimensional que contém elementos binary16 em sequência, sem descriptor (formato 0x0506 do Issuer ADHOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR guarda em sequência, sem descriptor, os padrões de bits de interchange binary16 do IEEE 754.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0506`. Família NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Regras de interpretação

- O número de elementos é o número de WORDs do Payload. Preservam-se tal como estão os padrões de bits, inclusive o payload de NaN e o zero com sinal.
- Não há ABI padding entre os elementos nem no final.

## Validade

- O Payload deve ter 1 WORD ou mais. Este formato, que não tem descriptor, não admite vector vazio.
- O tamanho do Payload deve ser um múltiplo inteiro da largura do elemento, 1 WORD.

## Base normativa e status do formato

- O interchange format dos elementos binary16 segue o [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- A sequência contígua unidimensional sem descriptor, a TAG/Length do GEUL e a disposição de WORD big-endian de 16 bits são um formato próprio do GEUL. Como o [`DLDataType` do DLPack](https://dmlc.github.io/dlpack/latest/c_api.html) pressupõe native-endian, este Payload não é a wire serialization do DLPack, do Arrow nem do ONNX.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).

## Exemplo

- O Payload `3c00 8000` são o binary16 `1.0` e `-0`, num registro de 5 WORD no total.
