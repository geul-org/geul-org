---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST é um Value de largura fixa que contém o resultado completo do SHA-256, da família SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SHA-256-DIGEST` (BIND do documento de especificação `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Documento de especificação | `0x00000000/codecs/0x000007C0/` (alvo de DECLARE `07C0`) |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 28 |
| Kind | Value · família: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Resultado SHA-256 com Payload fixo de 16 WORDs |
| Lado Hugo | `value/binary/sha-256-digest.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valor bruto de 16 WORDs |  |  |

SHA-256-DIGEST é um Value de largura fixa que contém o resultado completo do SHA-256, da família SHA-2. Código direto de Value `0x07CL`, família BINARY. O Payload é exatamente 16 WORDs (256 bits), e não se permite truncamento (truncation).

## Layout {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
TAG de extensão de Length   1 WORD  0x0012 (18 WORDs no total)
Payload           16 WORDs  SHA-256 Digest
```

## Interpretação e validade {#해석과-유효성}

- Os 32 octetos do Payload são lidos na própria ordem de saída do SHA-256. Em cada WORD, o octeto alto vem primeiro.
- Não se aplica nenhuma conversão de endian de GEUL à bit string do digest. Apenas se agrupa a sequência de octetos de saída, dois a dois e em ordem, para fazer o framing em WORDs big-endian de 16 bits.
- Rejeita-se uma representação cujo Payload não seja de 16 WORDs ou cujo resultado tenha sido truncado arbitrariamente. Não há descriptor nem padding.

## Base normativa {#표준-근거}

- O algoritmo SHA-256 e o resultado de 256 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- O TAG, o Length e o framing em WORDs de 16 bits de GEUL são regras que este formato acrescenta e não fazem parte do algoritmo SHA-2.

## Comprimento {#길이}

- O total é exatamente 18 WORDs, a soma de 1 WORD de TAG, 1 WORD de TAG de extensão de Length e 16 WORDs de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 16 WORDs, rejeita-se.

## Exemplo {#예시}

- Os octetos do digest, de `d[0]` a `d[31]`, são dispostos em ordem nos WORDs do Payload, de `(d[0]<<8)|d[1]` a `(d[30]<<8)|d[31]`. O Length total é sempre 18 WORDs.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000007C0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
