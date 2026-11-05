---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST é um Value de largura fixa que contém o resultado completo do SHA-1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SHA1-DIGEST` (BIND do documento de especificação `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Documento de especificação | `0x00000000/codecs/0x000007D0/` (alvo de DECLARE `07D0`) |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 29 |
| Kind | Value · família: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Resultado SHA-1 com Payload fixo de 10 WORDs. Apenas para identificação, como IDs de objetos git |
| Lado Hugo | `value/binary/sha1-digest.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valor bruto de 10 WORDs |  |  |

SHA1-DIGEST é um Value de largura fixa que contém o resultado completo do SHA-1. Código direto de Value `0x07DL`, família BINARY. O Payload é exatamente 10 WORDs (160 bits), e não se permite truncamento (truncation).

**Usa-se apenas para identificação.** A resistência a colisões do SHA-1 foi quebrada (SHAttered, 2017). Como base de integridade ou de assinatura, usa-se [SHA-256-DIGEST](0x07CL-sha-256-digest.md). Este formato existe para conter, tal como estão, identificadores já definidos com SHA-1, tipicamente o ID de objeto (ID de commit) de um repositório git SHA-1. Por exemplo, a Version (ID de commit) de [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) é contida em 11 WORDs, em vez de em texto hex (22 WORDs).

## Layout {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORDs  SHA-1 Digest
```

## Interpretação e validade {#해석과-유효성}

- Os 20 octetos do Payload são lidos na própria ordem de saída do SHA-1. Em cada WORD, o octeto alto vem primeiro (mesmo framing de SHA-256-DIGEST).
- Rejeita-se uma representação cujo Payload não seja de 10 WORDs ou cujo resultado tenha sido truncado arbitrariamente (como o ID abreviado do git). Não há descriptor nem padding.
- O ID de objeto do git é o valor calculado pelo próprio git, tal como está. O SHA-1 do git é uma variante com detecção de colisões (SHA-1DC), mas, para entradas que não são ataques de colisão, o resultado é igual ao do SHA-1.

## Base normativa {#표준-근거}

- O algoritmo SHA-1 e o resultado de 160 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- O TAG de GEUL e o framing em WORDs de 16 bits são regras que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 11 WORDs, a soma de 1 WORD de TAG e 10 WORDs de Payload, e usa `LLLL=1010`. Não há extensão de Length.

## Exemplo {#예시}

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000007D0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
