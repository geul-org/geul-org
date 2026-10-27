---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT é o Meta de linhagem que registra o hash de conteúdo da versão imediatamente anterior (git parent). Se houver vários, é um merge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o hash de conteúdo da versão imediatamente anterior (git parent).

## Layout

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[TAG estendida de Length]
Payload           um Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x30`, classe de linhagem (`011`)
- Payload: Value embutido ([SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/))
- Quantidade: pode haver vários (merge)

## Interpretação e validade

- Se não houver, é a primeira versão; se houver vários, é um merge (git merge commit).
- Como entra no [hash de conteúdo](/pt/grammar/document/#hash-de-conteúdo), todo o histórico forma uma cadeia de hashes.
- O documento da lista de versões aponta para o documento de lista anterior ([PUBLICATION](/pt/grammar/edge/publication/)).
- O formato do digest é embutido como Value para deixar espaço para trocar o algoritmo de hash. Por ora, o hash de conteúdo é só SHA-256.

## Exemplo

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta de 20 WORD = TAG + extensão de Length + Value embutido de 18 WORD)
