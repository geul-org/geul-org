---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL é o Value que representa os valores lógicos false e true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `BOOL` (BIND `BOOL` do documento de especificação) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Documento de especificação | `0x00000000/codecs/0x00000600/` (alvo do DECLARE `0600`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 0 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | false ou true em 1 WORD fixa |
| Lado Hugo | `value/numeric/bool.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor bruto de 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL é o Value que representa os valores lógicos false e true. É o direct code de Value `0x060L`, família NUMERIC. É um tipo distinto de SIGNED-INTEGER e UNSIGNED-INTEGER, que guardam os números 0 e 1.

## Layout {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretação e validade {#해석과-유효성}

- Payload `0000` é false e `0001` é true.
- Não há padding nem descriptor.
- O Payload é exatamente `0000` ou `0001`. Qualquer outro valor de 16 bits é rejeitado como invalid.
- Qualquer outra representação de Length é rejeitada como invalid.

## Comprimento {#길이}

- O total é exatamente 2 WORD, somando 1 WORD de TAG e 1 WORD de Payload, e usa o comprimento direto `LLLL=0001`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 1 WORD, é rejeitado.

## Exemplo {#예시}

| Registro completo (TAG + Payload) | Payload | Julgamento |
|---|---|---|
| `0601 0000` | `0000` | false, canônico |
| `0601 0001` | `0001` | true, canônico |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG com Length diferente de `0001` + `0000` ou `0001` | `0000` ou `0001` | invalid |

## Status de formato {#형식-지위}

- Esta representação, que une a code word de 16 bits `0000`/`0001` ao TAG do GEUL, é um scalar profile próprio do GEUL.
- O valor lógico em si é universal, mas não se afirma nenhum padrão industrial único que corresponda a esta representação de 1 WORD.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000600/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
