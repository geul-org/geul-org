---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL é o Meta de definição que declara, como Value de data ou timestamp, o fim da validade desta versão (lei temporária)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara o fim da validade desta versão (lei temporária). A partir desse instante, esta versão não está em vigor.

## Layout

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[TAG estendida de Length]
Payload           um Value TIME
```

- Codec: Meta `0x14`, classe de definição (`001`)
- Payload: Value embutido ([GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) ou [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/))
- Quantidade: no máximo um

## Interpretação e validade

- Se não houver, é válida até a entrada em vigor da próxima versão.
- Passado o prazo de validade, não há edição em vigor. A edição antiga não ressuscita.
