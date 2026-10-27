---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE é o Meta de definição que declara, como Value de idioma, o idioma padrão dos textos do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara o idioma padrão dos textos do documento. Um texto sem idioma escrito à parte está nesse idioma.

## Layout

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[TAG estendida de Length]
Payload           um Value de idioma
```

- Codec: Meta `0x16`, classe de definição (`001`)
- Payload: Value embutido ([LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/) ou [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/))
- Quantidade: no máximo um

## Interpretação e validade

- O documento TANGEUL registra o locale de redação (por exemplo, `en`, `ko`).

## Exemplo

- `en`: `0x1916 0x08C6 0x656E`
