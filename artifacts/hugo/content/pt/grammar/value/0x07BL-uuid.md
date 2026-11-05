---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID é um Value de largura fixa que contém o valor de 128 bits de um UUID da RFC 9562."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `UUID` (BIND do documento de especificação `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Documento de especificação | `0x00000000/codecs/0x000007B0/` (alvo de DECLARE `07B0`) |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 27 |
| Kind | Value · família: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | UUID de 128 bits da RFC 9562, com Payload fixo de 8 WORDs |
| Lado Hugo | `value/binary/uuid.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | valor bruto de 8 WORDs |  |  |

UUID é um Value de largura fixa que contém o valor de 128 bits de um UUID da RFC 9562. Código direto de Value `0x07BL`, família BINARY. O Payload é exatamente 8 WORDs (16 octetos, 128 bits).

## Layout {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  9 WORDs no total
Payload           8 WORDs (128 bits)  octeto 0 → octeto 15 do UUID
```

## Interpretação e validade {#해석과-유효성}

- Os octetos canonical do UUID da RFC 9562, do octeto 0 ao octeto 15, são agrupados em ordem, dois octetos por vez. O octeto que vem primeiro forma os 8 bits altos do WORD. Os campos, os bits de versão e os bits de variante do UUID não são reordenados nem recodificados.
- A cadeia hex-and-dash `8-4-4-4-12` é apenas uma representação de entrada e saída. Maiúsculas/minúsculas e hífens não entram no Payload; armazenam-se somente os 16 octetos resultantes da análise.
- Este Value UUID preserva sem perdas o padrão de 128 bits. Na variante `10xx` da RFC 9562, as versões 1, 3, 4, 5, 6 e 7 têm layout padrão e a versão 8 é um formato de UUID personalizado (custom). A versão 2 é reservada para DCE Security e a RFC não define seu layout; a versão 0 é unused e as versões 9–15 são reservadas para definição futura. As outras variantes também são reservadas, para compatibilidade ou definição futura.
- O Nil UUID é o valor especial com os 128 bits todos em zero, e o Max UUID, com os 128 bits todos em um. Padrões de 128 bits que incluam versões/variantes reservadas ou unused também não são excluídos estruturalmente; o significado e a interoperabilidade desses padrões são julgados pelo padrão aplicável e pelo contexto externo.
- A identidade de UUID é julgada por serem iguais os valores de 128 bits do Payload. O fato de serem o mesmo valor não garante autenticação, propriedade, existência atual, resolubilidade nem direito de acesso do alvo.
- Ao armazenar um GUID COM da Microsoft, não se copia como está a representação de memória/serialização mixed-endian. Converte-se primeiro para 16 octetos na ordem canonical de campos/octetos da RFC 9562.
- Se o Payload não for exatamente 8 WORDs, rejeita-se.

## Base normativa {#표준-근거}

- A [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) define o UUID como 16 octetos (128 bits) e manda codificar os campos most-significant-byte-first, de modo que no formato binário os campos se sucedam em ordem big-endian. A variante está nos bits altos do octeto 8 e a versão nos 4 bits altos do octeto 6, e este formato preserva essas posições tal como estão.
- As Seções 4.1–5.10 da RFC 9562 distinguem a variante e as versões 1–8, Nil, Max e as faixas reservadas. A RFC 9562 substitui a RFC 4122, portanto a norma vigente deste formato é a RFC 9562.
- O ABNF hex-and-dash da RFC 9562 é uma representação em texto, e a RFC também indica à parte a ressalva do GUID COM little-endian. GEUL coloca no Payload apenas os 16 octetos canonical do UUID da RFC.
- O TAG de GEUL, o Length direto e o framing em WORDs de 16 bits não fazem parte da RFC 9562; são regras que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 9 WORDs, 1 WORD de TAG mais 8 WORDs de Payload, e usa o comprimento direto `LLLL=1000`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORDs, rejeita-se.

## Exemplo {#예시}

UUIDv7 test vector do Apêndice A.6 da RFC 9562, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000007B0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
