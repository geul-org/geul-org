---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD é o Edge descritivo que declara um campo do Payload de um Codec (Codec 0x1C). Registra o DECLARE a que pertence e a largura (registro, valor bruto de n WORDs, valor bruto restante)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD é o Edge descritivo que declara um campo do Payload de um Codec. Codec `0x1C`.

O FIELD aponta para o seu [DECLARE](/pt/grammar/edge/declare/). Os FIELDs que apontam para um mesmo DECLARE compõem o Payload na ordem em que aparecem no documento. O layout é incorporado ao decodificador ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1100
Edge Id           registro Reference LOCAL
DECLARE           registro Reference LOCAL. O Edge DECLARE a que este campo pertence
Largura           1 WORD. 0 = registro, n (1~65534) = valor bruto de n WORDs, 0xFFFF = valor bruto restante
```

## Interpretação e validade

- O DECLARE aponta para um Edge DECLARE do mesmo documento. Um FIELD pertence a um só DECLARE. A ordem não é escrita à parte: é a ordem em que os registros FIELD estão no documento.
- O documento de especificação de FIELD declara o DECLARE como um campo de largura `0` (registro), CODEC `0008` (LOCAL). Por isso, no grafo do visualizador, aparece desenhado como a ligação FIELD → DECLARE.
- A largura `0` é um campo de registro. Começa com uma TAG WORD e é lido pelo Length dessa TAG (regras de interpretação de [DECLARE](/pt/grammar/edge/declare/)).
- A largura `n` (1~65534) é um campo de valor bruto. Sempre tem exatamente n WORDs.
- A largura `0xFFFF` é o valor bruto restante. Só há um por DECLARE, e pode estar no início, no meio ou no fim. A largura é o que sobra das WORDs restantes, determinadas pelo Length da TAG do registro externo, menos a largura dos campos seguintes. Por isso, todos os campos depois do campo restante devem ser valores brutos de largura fixa (um registro só tem fim conhecido lendo-se do início). Pode ter 0 WORD. Não se anexa ENUM.
- O Kind·Codec aceito pelo campo especifica-se com [CODEC](/pt/grammar/edge/codec/). Um campo de registro, sem CODEC, aceita qualquer registro; com CODEC, deve ser um deles. Se um campo de valor bruto tiver um CODEC, esse valor bruto é interpretado como o Value, sem a TAG.
- O nome do campo liga-se ao Edge Id do FIELD por [BIND](/pt/grammar/edge/bind/) (por exemplo, `doc`, `hash`). Todos os UTF8-TEXT anexados a DECLARE, FIELD, ENUM e CODEC são feitos com BIND, e não se anexam com outros Edges como LABEL.
- O significado dos valores de código de um campo de valor bruto é anexado por [ENUM](/pt/grammar/edge/enum/).
- Um campo que aponta para outro nó do grafo não é marcado à parte. Se o campo de registro é uma Reference, essa é a ligação.

## Comprimento

```
total = 1 + 2 + 2 + 1 WORD   (quando Edge Id e DECLARE são IDs LOCAL de 1 WORD)
```

## Exemplo (não normativo)

- Campo de registro: Edge Id 7, DECLARE #1, largura `0`. TAG 1 + Edge Id 2 + DECLARE 2 + largura 1 = 6 WORDs. Para aceitar só LOCAL, veja o exemplo de [CODEC](/pt/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- Para campos de valor bruto, como o hash de conteúdo, veja o exemplo de [DECLARE](/pt/grammar/edge/declare/).

## Páginas relacionadas

- [DECLARE](/pt/grammar/edge/declare/), [ENUM](/pt/grammar/edge/enum/), [CODEC](/pt/grammar/edge/codec/), [BIND](/pt/grammar/edge/bind/)
- [Documento de especificação de Codec](/pt/grammar/codec-spec/)
