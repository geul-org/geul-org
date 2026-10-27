---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE é o Meta de política que registra restrições de uso, como a proibição de treinamento e de uso comercial."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra restrições de uso (por exemplo, proibição de treinamento, proibição de uso comercial).

## Layout

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[TAG estendida de Length]
Payload           texto ou Reference que expressa a restrição de uso
```

- Codec: Meta `0x55`, classe de política (`101`)
- Payload: Value ou Reference embutido
- Quantidade: pode haver vários

## Questões em aberto

- Tabela de códigos dos tipos de restrição.
