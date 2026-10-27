---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE é o Meta de política que registra a licença deste documento e das obras contidas na sequência de bytes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra a licença deste documento e das obras contidas na sequência de bytes.

## Layout

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[TAG estendida de Length]
Payload           Reference que aponta para a licença, ou UTF8-TEXT com identificador SPDX, ou Value URI
```

- Codec: Meta `0x50`, classe de política (`101`)
- Payload: Reference ou Value embutido ([UTF8-TEXT](/pt/grammar/value/text/utf8-text/), [URI](/pt/grammar/value/text/uri/))
- Quantidade: no máximo um

## Interpretação e validade

- Os documentos publicados no geul.org são CC0. Na publicação privada, quem decide é o Issuer ([Issuer](/pt/grammar/issuer/)).
- Registra-se a licença original da obra de origem.

## Questões em aberto

- Se o identificador SPDX fica como texto ou como Reference a uma entidade GEUL.
