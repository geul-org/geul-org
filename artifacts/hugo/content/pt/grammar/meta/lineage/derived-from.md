---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM é o Meta de linhagem que registra o documento ou material de outra linhagem do qual este documento deriva."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra que este documento deriva de um documento ou material de outra linhagem.

## Layout

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[TAG estendida de Length]
Payload           Reference, ou SHA-256-DIGEST (hash de conteúdo), ou Value URI
```

- Codec: Meta `0x31`, classe de linhagem (`011`)
- Payload: Reference ou Value embutido
- Quantidade: pode haver vários

## Interpretação e validade

- Se deriva de um documento GEUL, põe-se o seu hash de conteúdo ([SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/)); se for material externo, uma [URI](/pt/grammar/value/text/uri/). Para fixar a edição de um material externo por hash, acrescenta-se ao [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD um QUALIFIER de hash do texto original (P4092).
- A fonte por registro fica a cargo do Edge de fundamento [SOURCE](/pt/grammar/edge/source/), e o registro antigo, antes de mudança de lugar, divisão ou fusão, fica a cargo do QUALIFIER P1365 do Edge alvo (com valor = Edge Id antigo).
