---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS é um formato fixo de 11 WORD do Issuer IETF que contém os 128 bits de um endereço IPv6 na ordem original."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS é o Value de largura fixa que contém o valor de 128 bits de um endereço IPv6. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0020` IETF, número de formato `0xC002`, família BINARY. O Payload tem exatamente 8 WORD (128 bits).

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interpretação e validade

- As oito WORDs do Payload, concatenadas a partir da WORD superior, são lidas como os 128 bits do campo de endereço IPv6, na ordem original. Em cada WORD, o octeto que vem primeiro são os 8 bits superiores.
- O Payload contém apenas os 128 bits de um endereço. Não contém o comprimento do prefixo CIDR, a porta nem o protocolo de transporte.
- O zone identifier não está nos 128 bits do endereço e, por isso, não vai no Payload. Um scoped address que precise de zone é dado por contexto externo, como a interface ou um Edge, Reference ou Profile.
- Pode representar todos os padrões de 128 bits. O significado operacional e a possibilidade de uso de padrões unspecified, loopback, multicast, especiais e reservados se julgam no contexto externo, e não limitam a validade estrutural.
- IPV4-ADDRESS e IPV6-ADDRESS são formatos distintos. Um endereço IPv6 IPv4-mapped também se preserva como valor IPv6 de 128 bits e não se equipara automaticamente a IPV4-ADDRESS nem se normalizam entre si.
- Este Value pode ser usado como componente identificador de uma Reference, mas o scope e a política de referência não estão contidos no padrão de bits do endereço.

## Base normativa

- A [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) define o endereço IPv6 como um identificador de 128 bits e define o formato de bits dos endereços, inclusive unicast, anycast, multicast e IPv4-mapped IPv6. Este formato preserva esses 128 bits sem reinterpretá-los.
- A [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) define o Source Address e o Destination Address do pacote IPv6, cada um como campo de 128 bits. As WORDs do Payload preservam a ordem do bit de ordem superior ao de ordem inferior desse campo de endereço.
- A [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) esclarece que a zone de um endereço não global não é codificada no próprio endereço, e sim determinada pelo contexto. Por isso o zone identifier fica fora do Payload.
- A notação em cadeia da RFC 4291 só pode ser usada em explicações e em entrada e saída. A [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) não define o formato de armazenamento interno, e por isso não se usa a canonicalization de cadeia dela como canonicalization deste registro binário.
- A TAG do GEUL, a atribuição do Issuer, o Length direto e o framing de WORD de 16 bits não fazem parte dessas RFCs, e sim regras que este formato acrescenta.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

Endereço IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- A notação abreviada da cadeia não afeta o Payload.
