---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM é o Meta de linhagem que registra o hash de conteúdo da versão original de onde se trouxe uma mudança de outra linhagem (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o hash de conteúdo da versão original de onde se trouxe uma mudança de outra linhagem (git cherry-pick `-x`).

## Layout

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[TAG estendida de Length]
Payload           um Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x34`, classe de linhagem (`011`)
- Payload: Value embutido ([SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/))
- Quantidade: pode haver vários

## Interpretação e validade

- O formato do digest é embutido como Value para deixar espaço para trocar o algoritmo de hash. Por ora, o hash de conteúdo é só SHA-256.
