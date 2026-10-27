---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY é o Meta de linhagem que registra quem gerou o documento (pessoa, modelo, motor de regras) e a sua versão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra quem gerou o documento. Pode ser uma pessoa, um modelo ou um motor de regras.

## Layout

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[TAG estendida de Length]
Gerador           Reference (pessoa, modelo, motor de regras)
Versão            Value UTF8-TEXT, ou marcador de omissão 0x0000 (campo opcional)
```

- Codec: Meta `0x32`, classe de linhagem (`011`)
- Payload: Reference embutida + texto da versão (opcional)
- Quantidade: pode haver vários

## Interpretação e validade

- Se for um modelo, escreve-se também a versão do modelo.
- Se não se conhece a versão ou não se quer pô-la, omite-se essa posição e escreve-se ABSENT (`0x0000`) ([CODEC](/pt/grammar/edge/codec/) campo opcional). A especificação `0x1832` do geul.org tem dois campos de registro: agent (sem CODEC) e version (`0840`, `0841`, `0000`).
- A versão do código-fonte de um programa (commit) é registrada com mais exatidão pelo formato (digest, obrigatório) de [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/). A versão de GENERATED-BY registra em texto o que não é um ID de commit, como o nome e a versão de um modelo.
- Nos documentos publicados no geul.org não se põe Reference que aponte para pessoa natural ([Issuer e publicação](/pt/grammar/issuer/#publicação-no-geulorg)). Aponta-se uma organização ou um Issuer. Como exceção, apontar uma pessoa natural por [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) é permitido.
