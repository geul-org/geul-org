---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE é o Meta de verificação que registra o grau de confiança do documento inteiro como um Value decimal entre 0 e 1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o grau de confiança do documento inteiro. O grau de confiança por registro escreve-se com um QUALIFIER anexado ao Edge alvo (a propriedade ainda não foi definida, [SOURCE](/pt/grammar/edge/source/#outras-formas-de-expressar-o-fundamento)).

## Layout

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[TAG estendida de Length]
Payload           Value UNSIGNED-DECIMAL, de 0 a 1
```

- Codec: Meta `0x43`, classe de verificação (`100`)
- Payload: Value embutido ([UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/))
- Quantidade: no máximo um

## Interpretação e validade

- Quem atribuiu o valor se registra junto com [GENERATED-BY](/pt/grammar/meta/lineage/generated-by/) etc.

## Questões em aberto

- A escala (0~1) e a relação com o julgamento TOULMIN.
