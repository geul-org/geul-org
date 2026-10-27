---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END é o Meta de estrutura de 1 WORD que fecha o documento. É obrigatório em todos os documentos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É o registro que fecha o documento.

## Layout

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[TAG estendida de Length]
```

- Codec: Meta `0x0F`, classe de estrutura (`000`)
- Payload: nenhum (1 WORD)
- Quantidade: um por documento, no final

## Interpretação e validade

- É obrigatório. A posição é conferida pelo comprimento de [DOC](/pt/grammar/meta/structure/doc/) (`DOC-*`).
- Se a entrada acabar sem END, o documento está truncado. Considerar ou não válido o conteúdo de um documento truncado é política do decodificador.
- Nada vem depois.

## Exemplo

- `0x180F`
