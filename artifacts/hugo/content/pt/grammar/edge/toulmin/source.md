---
title: "SOURCE e seções"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Formatos ISSUER do GEUL 0xC000~0xC005 que escrevem o texto original de autoria (SOURCE), as cadeias de caracteres (TEXT), as divisões de seção e de caso (SECTION, CASE-BEGIN, CASE-END) e o parágrafo descritivo (PROSE) de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registros que escrevem o texto original e as divisões de um documento TOULMIN. Todos são Edges que usam um número de formato sob `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL) ([TOULMIN](/pt/grammar/edge/toulmin/#formatos-issuer)).

## Formatos

| Número de formato | Nome | Layout |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD de largura SPAN, Value UTF8 |
| `0xC001` | TEXT | ID, Value UTF8 |
| `0xC002` | SECTION | ID, código de seção de 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (caso) |
| `0xC004` | CASE-END | ID, REF (caso) |
| `0xC005` | PROSE | ID, SPAN |

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](/pt/grammar/edge/toulmin/#campos-comuns)).
- O Value UTF8 é um registro Value [UTF8-TEXT](/pt/grammar/value/text/utf8-text/). Contém os bytes tal como estão.

## SOURCE

É o texto original de autoria inteiro. Todo SPAN é uma faixa de bytes dentro desse texto original.

```
ID
WORD de largura SPAN   2 bits superiores = largura (00=1, 01=2, 10=4, 11=8 WORDs), 14 bits restantes = 0
Texto original         registro Value UTF8-TEXT
```

- O SOURCE é o primeiro registro do BODY. Há um por documento.
- O SPAN tem dois campos: byte inicial e número de bytes. Cada campo é um inteiro sem sinal da largura (1/2/4/8 WORDs) determinada pela WORD de largura SPAN.

## TEXT

É um nome ou uma cadeia de caracteres. É apontado por REF nas listas F_WITH e F_GROUNDS de NODE e em LABEL e IMPORTED-FROM de LINK.

## SECTION

É o início de uma seção. O código de seção é de 1 WORD.

| Código | Seção | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | regras de expressão condicional |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- Não se usa `0`. As seções são declaradas na ordem destes códigos.
- O título da seção é o PROSE imediatamente depois do SECTION.

## CASE-BEGIN, CASE-END

- O âmbito de um caso fica entre o CASE-BEGIN e o CASE-END que apontam para o mesmo caso (NODE CASE-DECLARE).

## PROSE

É um parágrafo descritivo que não é regra. Apenas aponta para uma faixa do texto original (SPAN).

## Páginas relacionadas

- [TOULMIN](/pt/grammar/edge/toulmin/), [NODE](/pt/grammar/edge/toulmin/node/), [LINK](/pt/grammar/edge/toulmin/link/)
