---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT é o Meta de política que registra o âmbito e o fundamento do consentimento como Reference ou texto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o âmbito e o fundamento do consentimento.

## Layout

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[TAG estendida de Length]
Payload           Reference que aponta para o fundamento do consentimento, ou texto
```

- Codec: Meta `0x54`, classe de política (`101`)
- Payload: Reference ou Value embutido
- Quantidade: pode haver vários

## Questões em aberto

- Estrutura da expressão do âmbito (finalidade, período, fornecimento a terceiros).
