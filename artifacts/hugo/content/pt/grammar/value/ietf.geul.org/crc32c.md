---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C é um Value de largura fixa que guarda o resultado de um CRC-32C."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C é um Value de largura fixa que guarda o resultado de um CRC-32C. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número do Codec `0x0000C000`, família BINARY. O Payload tem exatamente 2 WORD (32 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total de 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número do Codec   2 WORD  0x0000C000
Payload           2 WORD  CRC32C 16bit superiores │ 16bit inferiores
```

## Interpretação e validade {#해석과-유효성}

- Na notação de parâmetros de CRC: width 32, polinômio de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- O inteiro sem sinal de 32 bits resultante do cálculo é armazenado na ordem de WORD big-endian. Esta serialização não é, por si, a disposição do campo SCTP Checksum do RFC 3309 nem o byte mapping do digest iSCSI do RFC 3720.
- Se o Payload não tiver 2 WORD, rejeita-se.

## Base normativa {#표준-근거}

- O cálculo do CRC-32C e o polinômio de Castagnoli e as regras de reflexão seguem a definição de CRC32C do [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) e do [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- A TAG do GEUL, o Length e o enquadramento do inteiro de 32 bits calculado em WORD big-endian de 16 bits são regras que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 7 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 2 WORD, e usa-se o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 2 WORD, rejeita-se.

## Exemplo {#예시}

O check value do CRC-32C do ASCII `123456789`, `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
