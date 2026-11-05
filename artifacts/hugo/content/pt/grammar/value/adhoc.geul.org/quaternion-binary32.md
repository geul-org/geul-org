---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 é um Value que representa um quaternion por quatro componentes IEEE 754 binary32, na ordem (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 é um Value que representa um quaternion por quatro componentes IEEE 754 binary32, na ordem `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000704`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total de 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretação e validade {#해석과-유효성}

- Cada componente é formado pelos interchange bits de um binary32 na ordem de WORD big-endian.
- O frame, a handedness, a unit norm e a equivalência `q/-q` são contexto externo e não fazem parte do sentido deste formato.
- O NaN payload e o bit pattern do zero com sinal são preservados, e não há ABI padding.
- O Payload tem exatamente 8 WORD. Este formato não impõe unit norm nem normalização `q/-q`.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A ordem `x, y, z, w` é a mesma da ordem dos componentes de quaternion da [especificação/registry glTF 2.0](https://registry.khronos.org/glTF/) da Khronos, e cada componente é um [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- A rotation de node do glTF exige um unit quaternion com W escalar. Este formato é um quaternion geral que não impõe unit norm nem o sentido de rotation; portanto, não se pode considerá-lo igual à rotation do glTF, salvo se um profile externo acrescentar essa condição.

## Comprimento {#길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.

## Exemplo {#예시}

- Os componentes `(0.0, 0.0, 0.0, 1.0)` são um valor válido, que guarda os quatro bit patterns na ordem.
