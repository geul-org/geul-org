---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Registra o resultado do julgamento do documento inteiro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `VERDICT` (BIND `VERDICT` do documento de especificação) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Documento de especificação | `0x00000000/codecs/0x00001E90/` (alvo do DECLARE `1E90`) |
| Seção | 15 `1111` (Meta), deslocamento C = 9 na seção |
| Kind | Meta · classe: verificação |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Resultado do julgamento do documento inteiro. Pass, Review, Fail. Por nó ou registro, [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| Lado Hugo | `meta/verification/verdict.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | valor bruto 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Registra o resultado do julgamento do documento inteiro. O julgamento por nó ou registro cabe a [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[TAG de extensão de Length]
Julgamento        1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, classe de verificação
- Payload: valor bruto (julgamento, 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Por ser da classe de verificação, fica de fora do hash de conteúdo.
- O julgamento sobre outro documento fica no BODY de um documento diferente do julgado.

## Problemas em aberto {#열린-문제}

- Resta decidir se o agente e o fundamento do julgamento também serão registrados.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E90/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
