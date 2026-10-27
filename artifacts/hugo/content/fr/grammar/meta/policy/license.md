---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE est un Meta de politique qui consigne la licence de ce document et des œuvres contenues dans la suite d'octets."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne la licence de ce document et des œuvres contenues dans la suite d'octets.

## Disposition

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[TAG d'extension de Length]
Payload           Reference désignant la licence, ou UTF8-TEXT contenant un identifiant SPDX, ou Value URI
```

- Codec : Meta `0x50`, classe de politique (`101`)
- Payload : Reference ou Value intégré ([UTF8-TEXT](/fr/grammar/value/text/utf8-text/), [URI](/fr/grammar/value/text/uri/))
- Nombre : au plus un

## Interprétation et validité

- Un document publié sur geul.org est sous CC0. Pour une publication privée, c'est l'Issuer qui décide ([Issuer](/fr/grammar/issuer/)).
- Consigne la licence d'origine de l'œuvre source.

## Problèmes ouverts

- Placer l'identifiant SPDX sous forme de texte ou de Reference vers une entité GEUL.
