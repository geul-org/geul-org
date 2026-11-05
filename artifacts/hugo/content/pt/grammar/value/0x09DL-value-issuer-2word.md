---
title: "VALUE-ISSUER-2WORD (0x09DL)"
weight: 157
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-2WORD é um formato de Value definido por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-2WORD é um formato de Value definido por um Issuer. É uma das três últimas posições da zona de Value e tem Issuer de largura 2 WORDs. O layout de ISSUER é o mesmo nos três Kinds ([Registro e TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Valor |
|---|---|
| Nome | `VALUE-ISSUER-2WORD` (BIND do documento de especificação `VALUE-ISSUER-2WORD`) |
| TAG ID | `0x09DL` |
| Codec ID | `0x000009D0` |
| Documento de especificação | `0x00000000/codecs/0x000009D0/` (alvo de DECLARE `09D0`) |
| Seção | 4 `0100` (Value), deslocamento C dentro da seção = 29 |
| Kind | Value · classificação: formato de Issuer |
| TAG WORD | `0000 1001 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Issuer de 2 WORDs e número de Codec de 2 WORDs. O formato é definido pelo documento de Codec do Issuer |
| Lado Hugo | `value/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG de extensão de Length]
Issuer            2 WORDs
Número de Codec   2 WORDs. Definido pelo Issuer
Payload           Definido pelo documento de Codec publicado pelo Issuer
```

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto de 2 WORDs |  |  |
| 2 | `codec` | #3 | valor bruto de 2 WORDs |  |  |
| 3 | `payload` | #4 | restante, valor bruto (`0xFFFF`) |  |  |

A composição de `payload` é definida pelo documento de Codec desse Issuer.

## Interpretação e validade {#해석과-유효성}

- GEUL conhece apenas o limite do Payload, por meio do Length. Um decodificador que não conhece o formato sabe até o Kind, o Length, o Issuer e o número de Codec, e salta o resto pelo Length.
- A interpretação do Payload é definida pelo documento de Codec do Issuer. Os Values em formato de Issuer registrados atualmente estão no [índice de Codec](../codec-index.md#value-issuer-형식).
- O Issuer é escrito na menor largura em que o valor cabe ([Issuer e publicação](../issuer.md#issuer-등급)). O Issuer de 2 WORDs pode escrever qualquer valor.
- O número de Codec tem 2 WORDs. O Issuer o atribui, sem repetição dentro do seu próprio `codecs/`, independentemente do Kind. Se os números se esgotarem, obtém-se mais um Issuer.
- O documento de Codec fica em `<Issuer>/codecs/<número de Codec>/` desse Issuer ([Endereço de publicação e lista de versões](../publishing.md#id-표기)).
- A licença de um formato de Issuer é definida por esse Issuer ([Issuer e publicação](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [Value — formato de Issuer](_index.md#issuer-형식), [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [Registro e TAG WORD](../record.md#issuer-형식-레코드), [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000009D0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009D000000000
BODY
#1 DECLARE 0x09D0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
