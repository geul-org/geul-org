---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 é um formato fixo de 11 WORD do Issuer ADHOC que contém um quaternion com quatro componentes binary32 na ordem (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 é o Value que representa um quaternion por quatro componentes IEEE 754 binary32 na ordem `(x, y, z, w)`. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0704`, família NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretação e validade

- Cada componente são bits de interchange binary32 em ordem de WORD big-endian.
- O frame, a handedness, a unit norm e a equivalência `q/-q` são contexto externo e não fazem parte do significado deste formato.
- Preservam-se os padrões de bits, inclusive o payload de NaN e o zero com sinal, e não há ABI padding.
- O Payload tem exatamente 8 WORD. Este formato não impõe unit norm nem a normalização `q/-q`.

## Base normativa e status do formato

- A ordem `x, y, z, w` é igual à ordem dos componentes do quaternion do [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) da Khronos, e cada componente é um [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- A rotation de um node do glTF exige um unit quaternion cujo W é o escalar. Como este formato é um quaternion geral, que não impõe unit norm nem o significado de rotation, não se pode vê-lo como igual à rotation do glTF, a menos que um profile externo acrescente essa condição.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

- Os componentes `(0.0, 0.0, 0.0, 1.0)` são um valor válido que guarda os quatro padrões de bits em ordem.
