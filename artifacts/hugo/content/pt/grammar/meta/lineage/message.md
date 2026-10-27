---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE é o Meta de linhagem que registra o motivo da mudança como texto com idioma (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o motivo da mudança (git commit message).

## Layout

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[TAG estendida de Length]
Mensagem          1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x38`, classe de linhagem (`011`)
- Payload: Value embutido ([UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/))
- Quantidade: no máximo um por idioma

## Interpretação e validade

- A mensagem e o idioma vão em um único UTF8-LANGUAGE-TEXT. Para um mesmo idioma há uma só MESSAGE.
- O documento de especificação do geul.org escreve com [CODEC](/pt/grammar/edge/codec/) `084A`, `084B`.
