---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS é um Value de largura fixa que guarda o valor de 128 bits de um endereço IPv6."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS é um Value de largura fixa que guarda o valor de 128 bits de um endereço IPv6. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número do Codec `0x0000C002`, família BINARY. O Payload tem exatamente 8 WORD (128 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total de 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número do Codec   2 WORD  0x0000C002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interpretação e validade {#해석과-유효성}

- Os 8 WORD do Payload, concatenados a partir do mais significativo, leem-se como os 128 bits do campo de endereço IPv6, na ordem original. Em cada WORD, o octeto que vem primeiro corresponde aos 8 bits superiores.
- O Payload guarda apenas os 128 bits de um único endereço. Não guarda CIDR prefix length, port nem transport protocol.
- O zone identifier não está contido nos 128 bits do endereço; portanto, não se coloca no Payload. Um scoped address que precise de zone é dado por um contexto externo, como a interface, ou um Edge, uma Reference ou um Profile.
- Todos os bit patterns de 128 bits podem ser representados. O significado operacional e a possibilidade de uso de patterns unspecified, loopback, multicast, especiais ou reservados são julgados em contexto externo e não limitam a validade estrutural.
- IPV4-ADDRESS e IPV6-ADDRESS são formatos distintos. Um endereço IPv6 IPv4-mapped também se preserva como valor IPv6 de 128 bits, e não se identifica automaticamente com IPV4-ADDRESS nem se normalizam entre si.
- Este Value pode ser usado como componente identificador de uma Reference, mas o scope e a política de referência não estão contidos no bit pattern do endereço.

## Base normativa {#표준-근거}

- O [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) define o endereço IPv6 como um identifier de 128 bits e estabelece o bit format do endereço, incluindo unicast, anycast, multicast e IPv4-mapped IPv6. Este formato preserva esses 128 bits sem reinterpretá-los.
- O [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) define o Source Address e o Destination Address do pacote IPv6 como campos de 128 bits cada. Os WORD do Payload preservam a ordem do high-order bit ao low-order bit desse campo de endereço.
- O [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) afirma que a zone de um endereço non-global não é encoded no próprio endereço, mas determinada pelo context. Por isso o zone identifier fica fora do Payload.
- A notação em cadeia de caracteres do RFC 4291 pode ser usada apenas para explicação e entrada/saída. O [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) não define o formato de armazenamento interno; portanto, a canonicalization de cadeia de caracteres dele não é usada como canonicalization deste registro binary.
- A TAG do GEUL, a atribuição de Issuer, o Length direto e o enquadramento em WORD de 16 bits não fazem parte desses RFC, mas são regras que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.

## Exemplo {#예시}

Endereço IPv6 `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- A abreviação da notação em cadeia de caracteres não afeta o Payload.
