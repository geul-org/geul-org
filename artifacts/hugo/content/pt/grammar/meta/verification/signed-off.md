---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF é o Meta de verificação que registra, como Reference, a confirmação do direito de contribuir (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É a confirmação do direito de contribuir (git `Signed-off-by`, DCO).

## Layout

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[TAG estendida de Length]
Payload           uma Reference
```

- Codec: Meta `0x42`, classe de verificação (`100`)
- Payload: Reference embutida
- Quantidade: pode haver vários

## Interpretação e validade

- Nos documentos publicados no geul.org não se põe Reference que aponte para pessoa natural ([Issuer e publicação](/pt/grammar/issuer/#publicação-no-geulorg)). Aponta-se uma organização ou um Issuer. Como exceção, apontar uma pessoa natural por [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) é permitido.
