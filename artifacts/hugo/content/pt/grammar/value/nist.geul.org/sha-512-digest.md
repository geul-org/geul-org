---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST é um Value de largura fixa que guarda o resultado completo do SHA-512, da família SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST é um Value de largura fixa que guarda o resultado completo do SHA-512, da família SHA-2. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, número do Codec `0x0000C000`, família BINARY. O Payload tem exatamente 32 WORD (512 bits) e não se admite truncamento (truncation).

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG estendida de Length   1 WORD  0x0026 (total de 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Número do Codec   2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## Interpretação e validade {#해석과-유효성}

- Os 64 octetos do Payload são lidos na própria ordem de saída do SHA-512. Em cada WORD, o octeto mais significativo vem primeiro.
- Não se aplica ao digest bit string nenhuma conversão de endian do GEUL. A sequência de octetos da saída é apenas agrupada em pares, na ordem, e enquadrada como WORD big-endian de 16 bits.
- Rejeita-se a representação cujo Payload não tenha 32 WORD ou que tenha o resultado truncado arbitrariamente. Não há descriptor nem padding.

## Base normativa {#표준-근거}

- O algoritmo SHA-512 e o resultado de 512 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- A TAG do GEUL, o Length e o enquadramento em WORD de 16 bits são regras que este formato acrescenta e não fazem parte do algoritmo SHA-2.

## Comprimento {#길이}

- O total é exatamente 38 WORD, somando TAG 1 WORD, TAG estendida de Length 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 32 WORD, e usa-se `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não tiver exatamente 32 WORD, rejeita-se.

## Exemplo {#예시}

- Os octetos do digest `d[0]` a `d[63]` são colocados em ordem, do WORD de Payload `(d[0]<<8)|d[1]` ao `(d[62]<<8)|d[63]`. O Length total é sempre 38 WORD.
