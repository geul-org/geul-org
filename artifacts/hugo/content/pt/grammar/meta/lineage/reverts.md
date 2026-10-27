---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS é o Meta de linhagem que registra o hash de conteúdo da versão alvo cuja mudança foi desfeita (git revert)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o hash de conteúdo da versão alvo cuja mudança foi desfeita (git revert).

## Layout

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[TAG estendida de Length]
Payload           um Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x35`, classe de linhagem (`011`)
- Payload: Value embutido ([SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/))
- Quantidade: pode haver vários

## Interpretação e validade

- O formato do digest é embutido como Value para deixar espaço para trocar o algoritmo de hash. Por ora, o hash de conteúdo é só SHA-256.
