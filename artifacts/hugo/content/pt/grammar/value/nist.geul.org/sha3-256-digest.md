---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST é um Value de largura fixa que guarda o resultado completo do SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST é um Value de largura fixa que guarda o resultado completo do SHA3-256. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, número do Codec `0x0000C001`, família BINARY. O Payload tem exatamente 16 WORD (256 bits) e não se admite truncamento (truncation).

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG estendida de Length   1 WORD  0x0016 (total de 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Número do Codec   2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretação e validade {#해석과-유효성}

- Os 32 octetos do Payload são lidos na própria ordem de saída do SHA3-256. Em cada WORD, o octeto mais significativo vem primeiro.
- Não se aplica ao digest bit string nenhuma conversão de endian do GEUL. A sequência de octetos da saída é apenas agrupada em pares, na ordem, e enquadrada como WORD big-endian de 16 bits.
- Rejeita-se a representação cujo Payload não tenha 16 WORD ou que tenha o resultado truncado arbitrariamente. Não há descriptor nem padding.

## Base normativa {#표준-근거}

- O algoritmo SHA3-256 e o resultado de 256 bits seguem o [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) do NIST. O [projeto Hash Functions](https://csrc.nist.gov/Projects/hash-functions) do NIST também apresenta o padrão SHA-3.
- A TAG do GEUL, o Length e o enquadramento em WORD de 16 bits são regras que este formato acrescenta e não fazem parte do algoritmo SHA-3.

## Comprimento {#길이}

- O total é exatamente 22 WORD, somando TAG 1 WORD, TAG estendida de Length 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 16 WORD, e usa-se `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não tiver exatamente 16 WORD, rejeita-se.

## Exemplo {#예시}

- Colocam-se os octetos do digest `d[0]` a `d[31]` nos 16 WORD do Payload, dois octetos por vez, na ordem de saída. O Length total é sempre 22 WORD.
