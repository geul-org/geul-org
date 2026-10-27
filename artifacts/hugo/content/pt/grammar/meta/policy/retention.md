---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION é o Meta de política que registra o prazo de retenção do documento como Value de instante de expiração ou de duração."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o prazo de retenção do documento.

## Layout

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[TAG estendida de Length]
Payload           instante de expiração (GREGORIAN-DATE etc.) ou duração (DURATION-SECONDS)
```

- Codec: Meta `0x53`, classe de política (`101`)
- Payload: Value embutido (família TIME: [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) etc., ou [DURATION-SECONDS](/pt/grammar/value/time/duration-seconds/))
- Quantidade: no máximo um

## Interpretação e validade

- Se for uma duração, conta-se a partir de [RECORDED-AT](/pt/grammar/meta/provenance/recorded-at/).
