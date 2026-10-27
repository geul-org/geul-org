---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY é o Meta de política que registra o nível de dados pessoais do documento em 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o nível de dados pessoais do documento.

## Layout

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[TAG estendida de Length]
Nível             1 WORD
```

- Codec: Meta `0x52`, classe de política (`101`)
- Payload: valor bruto (nível de 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade

- Não muda a interpretação. Define apenas o tratamento.

## Questões em aberto

- Tabela de códigos dos níveis (correspondência com a classificação da lei de proteção de dados pessoais).
