---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG é o Meta de linhagem que registra um nome imutável dado a uma versão (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra um nome imutável dado a uma versão (git annotated tag).

## Layout

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[TAG estendida de Length]
Nome              Value UTF8-TEXT-*
Alvo              Value SHA-256-DIGEST, ou marcador de omissão 0x0000 (campo opcional). Se omitido, esta versão
```

- Codec: Meta `0x39`, classe de linhagem (`011`)
- Payload: Value embutido (texto + hash de conteúdo opcional)
- Quantidade: pode haver vários

## Interpretação e validade

- O nome é [UTF8-TEXT](/pt/grammar/value/text/utf8-text/) e o alvo é [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/).
- Se o alvo for omitido (ABSENT `0x0000`, [CODEC](/pt/grammar/edge/codec/) campo opcional), é um nome dado ao próprio documento. O próprio hash de conteúdo não pode ser escrito dentro de si mesmo. A especificação `0x1839` do geul.org tem dois campos de registro: name (`0840`, `0841`) e target (`0861`, `0000`).
- O mesmo nome não se reutiliza em outra versão.

## Exemplo

- Nome `v1`, esta versão: `19B9 08C0 7631 0000`

## Questões em aberto

- Se o TAG ainda é necessário havendo ID de versão (número de ordem), e a divisão de papéis com o nome do documento (`BIND`).
