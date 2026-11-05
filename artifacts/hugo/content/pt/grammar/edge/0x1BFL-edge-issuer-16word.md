---
title: "EDGE-ISSUER-16WORD (0x1BFL)"
weight: 447
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-16WORD é um formato de Edge definido pelo Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-16WORD é um formato de Edge definido pelo Issuer. É um dos três últimos espaços da área de Edge, e a largura do Issuer é de 16 WORD. O layout ISSUER é o mesmo nos três Kind ([registro e TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Valor |
|---|---|
| Nome | `EDGE-ISSUER-16WORD` (BIND `EDGE-ISSUER-16WORD` do documento de especificação) |
| TAG ID | `0x1BFL` |
| Codec ID | `0x00001BF0` |
| Documento de especificação | `0x00000000/codecs/0x00001BF0/` (alvo do DECLARE `1BF0`) |
| Seção | 13 `1101` (Edge (últimos 3 espaços ISSUER)), deslocamento C = 31 dentro da seção |
| Kind | Edge · classificação: formato de Issuer |
| TAG WORD | `0001 1011 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Issuer de 16 WORD e número do Codec de 2 WORD. O formato é definido pelo documento de Codec do Issuer |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0001 1011 1111 LLLL      Codec 0x1BFL
[TAG estendida de Length]
Issuer            16 WORD
Número do Codec   2 WORD. Definido pelo Issuer
Edge Id           registro LOCAL Reference. Primeiro elemento após Issuer e número do Codec
Resto do Payload  Definido pelo documento de Codec publicado pelo Issuer
```

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)). O Edge Id de um Edge não é declarado como FIELD. O Edge Id de EDGE-ISSUER vem depois do número do Codec e antes do campo `payload` ([layout](#레이아웃)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto 16 WORD |  |  |
| 2 | `codec` | #3 | valor bruto 2 WORD |  |  |
| 3 | `payload` | #4 | valor bruto restante (`0xFFFF`) |  |  |

A composição de `payload` é definida pelo documento de Codec desse Issuer.

## Interpretação e validade {#해석과-유효성}

- O GEUL conhece apenas o limite do Payload, por meio de Length. Um decodificador que não conhece o formato reconhece até Kind, Length, Issuer e número do Codec, e salta o restante usando Length.
- O Payload começa com o Edge Id (Reference LOCAL) ([Edge](_index.md#레이아웃)). Os componentes após o Edge Id são definidos pelo documento de Codec do Issuer.
- O Issuer é escrito com a menor largura em que o valor cabe ([Issuer e publicação](../issuer.md#issuer-등급)). Se os 12 WORD superiores do valor do Issuer forem 0, é invalid. Esse valor é escrito com um código de largura menor.
- O número do Codec ocupa 2 WORD. O Issuer o atribui dentro do seu próprio `codecs/` sem sobreposição, independentemente do Kind. Se faltarem números, obtém-se mais um Issuer.
- O documento do Codec fica em `<Issuer>/codecs/<número do Codec>/` desse Issuer ([endereço de publicação e lista de versões](../publishing.md#id-표기)).
- A licença de um formato de Issuer é definida por esse Issuer ([Issuer e publicação](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de formato Issuer](_index.md#issuer-형식-edge), [EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md)
- [Registro e TAG WORD](../record.md#issuer-형식-레코드), [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001BF0/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BF000000000
BODY
#1 DECLARE 0x1BF0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
