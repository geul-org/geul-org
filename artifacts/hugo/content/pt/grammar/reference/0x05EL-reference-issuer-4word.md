---
title: "REFERENCE-ISSUER-4WORD (0x05EL)"
weight: 94
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-4WORD é um formato de Reference definido por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-4WORD é um formato de Reference definido por um Issuer. É uma das três últimas posições da região Reference e a largura do Issuer é de 4 WORD. O layout ISSUER dos três Kind é o mesmo ([registro e TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Valor |
|---|---|
| Nome | `REFERENCE-ISSUER-4WORD` (BIND `REFERENCE-ISSUER-4WORD` do documento de especificação) |
| TAG ID | `0x05EL` |
| Codec ID | `0x000005E0` |
| Documento de especificação | `0x00000000/codecs/0x000005E0/` (alvo do DECLARE `05E0`) |
| Seção | 2 `0010` (Reference diversas), deslocamento C na seção = 30 |
| Kind | Reference · classificação: formato de Issuer |
| TAG WORD | `0000 0101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Issuer de 4 WORD e número de Codec de 2 WORD. O formato é definido pelo documento de Codec do Issuer |
| Lado Hugo | `reference/reference-issuer.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0101 1110 LLLL      Codec 0x05EL
[TAG estendida de Length]
Issuer            4 WORD
número de Codec   2 WORD. Definido pelo Issuer
Payload           Definido pelo documento de Codec publicado pelo Issuer
```

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto de 4 WORD |  |  |
| 2 | `codec` | #3 | valor bruto de 2 WORD |  |  |
| 3 | `payload` | #4 | valor bruto restante (`0xFFFF`) |  |  |

A composição de `payload` é definida pelo documento de Codec desse Issuer.

## Interpretação e validade {#해석과-유효성}

- Por meio do Length, GEUL conhece apenas o limite do Payload. Um decodificador que não conhece o formato conhece até Kind, Length, Issuer e número de Codec, e salta o restante pelo Length.
- O significado do número de Codec, a quantificação e o que ele aponta são definidos pelo documento de Codec publicado pelo Issuer. Não se aplicam as regras comuns de Reference, como a menor largura do ID de alvo e a leitura de quantificação ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- O Issuer é escrito na menor largura em que o valor cabe ([Issuer e publicação](../issuer.md#issuer-등급)). Se os 2 WORD superiores do valor do Issuer forem 0, é invalid. Esse valor é escrito com o código de 2 WORD ([REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)).
- O número de Codec tem 2 WORD. O Issuer o atribui sem repetição dentro do seu `codecs/`, independentemente do Kind. Se os números acabarem, obtém-se mais um Issuer.
- O documento de codec fica em `<Issuer>/codecs/<número de Codec>/` desse Issuer ([endereço de publicação e lista de versões](../publishing.md#id-표기)).
- A licença de um formato de Issuer é definida por esse Issuer ([Issuer e publicação](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)
- [registro e TAG WORD](../record.md#issuer-형식-레코드), [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x000005E0/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005E000000000
BODY
#1 DECLARE 0x05E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
