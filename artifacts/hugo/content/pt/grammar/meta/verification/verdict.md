---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT é o Meta de verificação que registra em 1 WORD o resultado do julgamento do documento inteiro (Pass, Review, Fail)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o resultado do julgamento do documento inteiro. O julgamento por nó ou registro fica a cargo do `VERDICT` de [TOULMIN](/pt/grammar/edge/toulmin/) (Edge `0x78`).

## Layout

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[TAG estendida de Length]
Julgamento        1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, classe de verificação (`100`)
- Payload: valor bruto (julgamento de 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade

- Por ser da classe de verificação, fica fora do hash de conteúdo.
- O julgamento sobre outro documento fica no BODY de um documento diferente do alvo julgado.

## Questões em aberto

- Se o sujeito e o fundamento do julgamento são registrados juntos.
