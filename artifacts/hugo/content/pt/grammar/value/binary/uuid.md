---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID é um Value fixo de 9 WORD que contém o valor de 128 bits de um UUID da RFC 9562 nos 16 octetos canônicos tal como estão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID é o Value de largura fixa que contém o valor de 128 bits de um UUID da RFC 9562. Código direto de Value `0x60`, família BINARY. O Payload tem exatamente 8 WORD (16 octetos, 128 bits).

## Layout

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  total de 9 WORD
Payload           8 WORD (128 bits)  UUID octet 0 → octet 15
```

## Interpretação e validade

- Agrupam-se, na ordem, de dois em dois, os octetos canônicos do octeto 0 ao octeto 15 do UUID da RFC 9562. O octeto que vem primeiro são os 8 bits superiores da WORD. Não se reorganizam nem se recodificam os fields, os version bits e os variant bits do UUID.
- A cadeia hex-and-dash `8-4-4-4-12` é só uma representação de entrada e saída. Maiúsculas, minúsculas e traços não entram no Payload, e só se guardam os 16 octetos resultantes da análise.
- Este Value UUID preserva sem perdas o padrão de 128 bits. Com a variant `10xx` da RFC 9562, as versions 1, 3, 4, 5, 6 e 7 têm layout padrão e a version 8 é um formato de UUID personalizado. A version 2 é reservada para DCE Security e a RFC não define o seu layout, a version 0 é unused e as versions 9–15 são reservadas para definições futuras. As outras variants também são reservadas para compatibilidade ou definição futura.
- O Nil UUID é o valor especial com os 128 bits todos em zero, e o Max UUID, com os 128 bits todos em um. Também não se excluem estruturalmente padrões de 128 bits com version/variant reservados ou unused, e o significado e a interoperabilidade desses padrões julgam-se pela norma aplicável e pelo contexto externo.
- A identidade de um UUID julga-se por serem iguais os 128 bits do Payload. Ser o mesmo valor não garante a autenticação, a propriedade, a existência atual, a resolubilidade nem o direito de acesso do alvo.
- Ao armazenar o GUID COM da Microsoft, não se copia tal qual a representação mixed-endian de memória ou de serialização. Primeiro converte-se nos 16 octetos da ordem canônica de field/octeto da RFC 9562.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Base normativa

- A [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) define o UUID como 16 octetos (128 bits) e faz o encode dos fields em most-significant-byte-first, de modo que no binary format se encadeiam em ordem de field big-endian. A variant está nos bits superiores do octeto 8 e a version nos 4 bits superiores do octeto 6, e este formato preserva essas posições tal como estão.
- As Sections 4.1–5.10 da RFC 9562 distinguem a variant, as versions 1–8, Nil, Max e as faixas reservadas. Como a RFC 9562 substitui a RFC 4122, a norma vigente deste formato é a RFC 9562.
- O ABNF hex-and-dash da RFC 9562 é uma representação em texto, e o caveat do GUID COM little-endian também é indicado à parte. O GEUL só põe no Payload os 16 octetos canônicos do UUID da RFC.
- A TAG do GEUL, o Length direto e o framing de WORD de 16 bits não fazem parte da RFC 9562, e sim regras que este formato acrescenta.

## Comprimento

- O total é exatamente 9 WORD, a soma de 1 WORD de TAG e 8 WORD de Payload, e usa o comprimento direto `LLLL=1000`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

O test vector de UUIDv7 do Appendix A.6 da RFC 9562, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
