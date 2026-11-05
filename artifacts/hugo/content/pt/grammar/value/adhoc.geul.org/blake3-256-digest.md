---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST é um Value de largura fixa que guarda os primeiros 32 octetos (256 bits) da saída do modo hash padrão do BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST é um Value de largura fixa que guarda os primeiros 32 octetos (256 bits) da saída do modo hash padrão do BLAKE3. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x0000C000`, família BINARY. O Payload tem exatamente 16 WORD e não guarda o modo keyed hash, o modo de derivação de chave nem saídas XOF de outros comprimentos.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG estendida de Length   1 WORD  0x0016 (total de 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretação e validade {#해석과-유효성}

- O Payload corresponde aos primeiros 32 octetos do output stream do modo hash padrão do BLAKE3. A ordem da saída é preservada e, em cada WORD, o octeto mais significativo vem primeiro.
- Não se aplica à saída nenhuma conversão de endian do GEUL. A sequência de octetos da saída é agrupada em pares, na ordem, e enquadrada como WORD big-endian de 16 bits.
- Rejeita-se a representação cujo Payload não tenha 16 WORD ou que guarde o resultado de keyed_hash, de derive_key ou de XOF de outro comprimento. Não há descriptor nem padding.

## Base normativa {#표준-근거}

- A definição do algoritmo, dos modos e da saída segue o [repositório oficial de implementação](https://github.com/BLAKE3-team/BLAKE3) da equipe BLAKE3 e a [especificação do BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- A TAG do GEUL, o Length e o enquadramento em WORD de 16 bits são regras que este formato acrescenta e não fazem parte do algoritmo BLAKE3.

## Comprimento {#길이}

- O total é exatamente 22 WORD, somando TAG 1 WORD, TAG estendida de Length 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 16 WORD, e usa-se `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não tiver exatamente 16 WORD, rejeita-se.

## Exemplo {#예시}

- Colocam-se os octetos de saída `d[0]` a `d[31]` nos 16 WORD do Payload, dois octetos por vez, na ordem da saída. O Length total é sempre 22 WORD.
