---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER é a Reference de indicação-declaração que aponta para o próprio Issuer. O Payload é só o Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER é a Reference de indicação-declaração que aponta para o próprio Issuer. Torna-se o alvo do `BIND` do nome do Issuer, de `LABEL` e dos Edges de julgamento.

## Layout

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[TAG estendida de Length]
Issuer            1/2/4/16 WORD
```

- A largura do Issuer é o Payload inteiro. O Codec não divide a largura. Se a largura não for 1, 2, 4 ou 16 WORD, ou se o valor do Issuer couber numa largura menor, é invalid (forma canônica do Issuer).
- Se o Issuer for de 16 WORD, são 17 WORD no total, então se acrescenta 1 WORD de extensão de Length.
- Usa-se apenas o Quantifier `000` (Identified). Qualquer outro valor é invalid.
- O valor do Issuer segue a atribuição de [Issuer](/pt/grammar/issuer/).
- Usos: o Subject de BIND do índice de nomes de Issuer `issuers.geul` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-issuer)), o LABEL do nome de exibição do Issuer, o julgamento sobre o Issuer, o signatário, e outras posições em que o próprio Issuer é o alvo.
- O formato que aponta para o próprio Issuer é só o ISSUER-POINTER. Apontar para o Issuer com `EXTERNAL-ISSUER-*` usando ID de documento `0` e ID de alvo `0` é invalid.

## Exemplo

| Issuer | Sequência de WORDs |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/), [Issuer e publicação](/pt/grammar/issuer/)
