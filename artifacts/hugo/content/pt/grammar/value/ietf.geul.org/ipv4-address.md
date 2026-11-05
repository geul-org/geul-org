---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS é um Value de largura fixa que guarda o valor de 32 bits de um endereço IPv4."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS é um Value de largura fixa que guarda o valor de 32 bits de um endereço IPv4. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número do Codec `0x0000C001`, família BINARY. O Payload tem exatamente 2 WORD (32 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total de 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número do Codec   2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretação e validade {#해석과-유효성}

- Os octetos do endereço mantêm a network byte order. Em cada WORD, o octeto que vem primeiro corresponde aos 8 bits superiores e o seguinte, aos 8 bits inferiores.
- O Payload guarda apenas os 32 bits de um único endereço. Não guarda CIDR prefix length, port nem transport protocol.
- Todos os bit patterns de 32 bits podem ser representados. O significado operacional e a possibilidade de uso de patterns como unspecified, especial, reservado ou multicast são julgados em contexto externo e não limitam a validade estrutural.
- IPV4-ADDRESS e IPV6-ADDRESS são formatos distintos. Um endereço IPv6 IPv4-mapped não é convertido automaticamente para este formato nem normalizado para o mesmo valor.
- Este Value pode ser usado como componente identificador de uma Reference, mas a política de referência e o tempo de vida não estão contidos no bit pattern do endereço.
- Se o Payload não tiver exatamente 2 WORD, rejeita-se.

## Base normativa {#표준-근거}

- O [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) define o endereço IPv4 como de comprimento fixo de 4 octetos (32 bits) e define o Source Address e o Destination Address como campos de 32 bits cada. Preservam-se no Payload a ordem de transmissão dos octetos do Appendix B e a regra most-significant-bit-first de cada octeto.
- A TAG do GEUL, a atribuição de Issuer, o agrupamento em WORD de 16 bits e o Length não fazem parte do RFC 791, mas são regras de framing que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 7 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 2 WORD, e usa-se o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 2 WORD, rejeita-se.

## Exemplo {#예시}

Endereço IPv4 `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
