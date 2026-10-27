---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS est un Meta de lignée qui consigne le hachage du contenu de la version dont la modification a été annulée (git revert)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le hachage du contenu de la version dont la modification a été annulée (git revert).

## Disposition

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[TAG d'extension de Length]
Payload           une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x35`, classe de lignée (`011`)
- Payload : Value intégré ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/))
- Nombre : plusieurs possibles

## Interprétation et validité

- Le format de digest est intégré comme Value afin de laisser la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'utilise que SHA-256.
