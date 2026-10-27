---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE est un Meta de lignée qui consigne la raison d'une modification sous forme de texte accompagné de sa langue (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne la raison de la modification (git commit message).

## Disposition

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[TAG d'extension de Length]
message           1 Value UTF8-LANGUAGE-TEXT
```

- Codec : Meta `0x38`, classe de lignée (`011`)
- Payload : Value intégré ([UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/))
- Nombre : au plus un par langue

## Interprétation et validité

- Le message et sa langue sont contenus dans un seul UTF8-LANGUAGE-TEXT. Il n'y a qu'un MESSAGE par langue.
- Les documents de spécification de geul.org l'écrivent avec les [CODEC](/fr/grammar/edge/codec/) `084A` et `084B`.
