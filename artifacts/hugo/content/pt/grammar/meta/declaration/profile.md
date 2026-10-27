---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE é o Meta de definição que declara, como texto de nome e versão, o perfil aplicado ao documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara o perfil aplicado ao documento. Os mesmos registros passam a ser interpretados com os documentos de Codec definidos pelo perfil (por exemplo, `tangeul-1.0` é [TOULMIN](/pt/grammar/edge/toulmin/)).

## Layout

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[TAG estendida de Length]
Payload           Value UTF8-TEXT "<nome>-<major>.<minor>"
```

- Codec: Meta `0x11`, classe de definição (`001`)
- Payload: Value embutido ([UTF8-TEXT](/pt/grammar/value/text/utf8-text/))
- Quantidade: no máximo um

## Interpretação e validade

- Rejeitam-se perfis de major diferente. A diferença de minor é permitida (só mudanças aditivas).
- Sem perfil, lê-se apenas com a gramática básica do GEUL e as especificações de código direto.

## Exemplo

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Questões em aberto

- Registro de nomes de perfil (geul.org) e regras de nome.
- Se o perfil é apontado por ID de documento (IMPORT) ou posto como texto.
