---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES est un Meta de lignée qui consigne le hachage du contenu de la version réécrite (git amend, rebase). La version d'origine n'est pas effacée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le hachage du contenu de la version réécrite (git amend, rebase).

## Disposition

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[TAG d'extension de Length]
Payload           une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x36`, classe de lignée (`011`)
- Payload : Value intégré ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/))
- Nombre : plusieurs possibles

## Interprétation et validité

- La version d'origine n'est pas effacée (conservation de l'ancienne loi).
- Le format de digest est intégré comme Value afin de laisser la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'utilise que SHA-256.
