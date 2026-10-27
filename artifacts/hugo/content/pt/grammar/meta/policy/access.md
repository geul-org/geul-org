---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS é o Meta de política que registra o âmbito de divulgação do documento (público, interno, confidencial) como um nível de 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o âmbito de divulgação do documento.

## Layout

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[TAG estendida de Length]
Nível             1 WORD (0 público, 1 interno, 2 confidencial, outros reservados)
```

- Codec: Meta `0x51`, classe de política (`101`)
- Payload: valor bruto (nível de 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade

- Documentos confidenciais não são publicados ([Issuer](/pt/grammar/issuer/)).
- Não muda a interpretação. Define apenas o tratamento.

## Questões em aberto

- Tabela de códigos dos níveis.
