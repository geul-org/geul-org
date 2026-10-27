---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM est un Meta de lignée qui consigne les hachages du contenu des versions d'origine fusionnées en une seule (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne les hachages du contenu des versions d'origine fusionnées en une seule (git squash).

## Disposition

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[TAG d'extension de Length]
Payload           une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x37`, classe de lignée (`011`)
- Payload : Value intégré ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/))
- Nombre : plusieurs possibles (un par version d'origine)

## Interprétation et validité

- Le format de digest est intégré comme Value afin de laisser la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'utilise que SHA-256.
