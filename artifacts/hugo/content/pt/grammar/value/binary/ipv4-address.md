---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS é um formato fixo de 5 WORD do Issuer IETF que contém os 32 bits de um endereço IPv4 em network byte order."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS é o Value de largura fixa que contém o valor de 32 bits de um endereço IPv4. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0020` IETF, número de formato `0xC001`, família BINARY. O Payload tem exatamente 2 WORD (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total de 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretação e validade

- Os octetos do endereço ficam em network byte order tal como estão. Em cada WORD, o octeto que vem primeiro são os 8 bits superiores e o seguinte são os 8 bits inferiores.
- O Payload contém apenas os 32 bits de um endereço. Não contém o comprimento do prefixo CIDR, a porta nem o protocolo de transporte.
- Pode representar todos os padrões de 32 bits. O significado operacional e a possibilidade de uso de padrões como unspecified, especiais, reservados e multicast se julgam no contexto externo, e não limitam a validade estrutural.
- IPV4-ADDRESS e IPV6-ADDRESS são formatos distintos. Um endereço IPv6 IPv4-mapped não se converte automaticamente para este formato nem se normaliza como o mesmo valor.
- Este Value pode ser usado como componente identificador de uma Reference, mas a política de referência e o tempo de vida não estão contidos no padrão de bits do endereço.
- Se o Payload não for exatamente 2 WORD, rejeita-se.

## Base normativa

- A [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) define o endereço IPv4 como um comprimento fixo de 4 octetos (32 bits) e define o Source Address e o Destination Address, cada um como campo de 32 bits. Preserva-se no Payload a ordem de transmissão dos octetos e a regra most-significant-bit-first de cada octeto do Appendix B.
- A TAG do GEUL, a atribuição do Issuer, o agrupamento em WORD de 16 bits e o Length não fazem parte da RFC 791, e sim regras de framing que este formato acrescenta.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 2 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 2 WORD, rejeita-se.

## Exemplo

Endereço IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
