---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM é o Meta de linhagem que registra os hashes de conteúdo das versões originais reunidas em uma (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra os hashes de conteúdo das versões originais reunidas em uma (git squash).

## Layout

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[TAG estendida de Length]
Payload           um Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x37`, classe de linhagem (`011`)
- Payload: Value embutido ([SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/))
- Quantidade: pode haver vários (um por versão original)

## Interpretação e validade

- O formato do digest é embutido como Value para deixar espaço para trocar o algoritmo de hash. Por ora, o hash de conteúdo é só SHA-256.
