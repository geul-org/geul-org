---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM é o Edge descritivo que dá significado a um valor de código de um campo de valor bruto (Codec 0x1D). O nome liga-se por BIND."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM é o Edge descritivo que dá significado a um valor de código de um campo de valor bruto. Codec `0x1D`.

Junto com [FIELD](/pt/grammar/edge/field/), é o vocabulário para escrever a especificação de Codec. O layout é incorporado ao decodificador ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1101
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Campo             registro Reference LOCAL que aponta para o Edge FIELD
Valor de código   valor bruto. Mesmo número de WORDs que a largura desse FIELD
```

## Interpretação e validade

- O campo deve ser um FIELD de valor bruto (largura `n ≥ 1`). Não se anexa ENUM a campos de registro. O significado de um registro é dito pelo Codec desse registro.
- O valor de código tem exatamente a largura do FIELD. A fronteira é conferida pelo Length do registro ENUM.
- Num campo, o mesmo valor de código não se declara duas vezes.
- O nome do valor de código liga-se ao Edge Id do ENUM por [BIND](/pt/grammar/edge/bind/). Todos os UTF8-TEXT anexados a DECLARE, FIELD, ENUM e CODEC são feitos com BIND, e não se anexam com outros Edges como LABEL.
- Um valor de código não declarado não é erro. O visualizador mostra o valor bruto tal como está. Fechar ou não os valores permitidos fica a cargo da especificação do Codec, e o vocabulário atual não tem marca para fechar.

## Comprimento

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Exemplo (não normativo)

No campo da categoria do motivo (FIELD #4, valor bruto de 1 WORD) do documento de especificação de TOMBSTONE, declara-se o código `0x0001`. Edge Id 10. O nome é ligado à parte por BIND. Como a tabela de códigos da categoria do motivo ainda não está definida, o valor de código é um exemplo.

- TAG 1 + Edge Id 2 + campo 2 + valor de código 1 = 6 WORDs, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

O documento de especificação de TRIPLE põe três ENUM (`0`, `1`, `2`) no campo Rank (FIELD #5) e liga cada um com BIND a `normal`, `preferred` e `deprecated` ([TRIPLE](/pt/grammar/edge/triple/)).

## Páginas relacionadas

- [DECLARE](/pt/grammar/edge/declare/), [FIELD](/pt/grammar/edge/field/), [CODEC](/pt/grammar/edge/codec/), [BIND](/pt/grammar/edge/bind/)
- [Documento de especificação de Codec](/pt/grammar/codec-spec/)
