---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY é o Meta de estrutura de 1 WORD que encerra o HEAD do documento e inicia o BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É o registro que encerra o HEAD e inicia o BODY.

## Layout

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[TAG estendida de Length]
```

- Codec: Meta `0x0E`, classe de estrutura (`000`)
- Payload: nenhum (1 WORD)
- Quantidade: no máximo um por documento

## Interpretação e validade

- É omitido se o HEAD estiver vazio. Um documento sem `BODY` é todo BODY. Se o HEAD tiver Meta ou HEAD Edge (o [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do documento inteiro e seus QUALIFIERs), ele é colocado.
- Não tem Payload. Tem 1 WORD no total.

## Exemplo

- `0x180E`
