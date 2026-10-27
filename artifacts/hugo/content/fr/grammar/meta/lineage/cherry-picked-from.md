---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM est un Meta de lignée qui consigne le hachage du contenu de la version d'origine dont une modification a été reprise d'une autre lignée (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le hachage du contenu de la version d'origine dont une modification a été reprise d'une autre lignée (git cherry-pick `-x`).

## Disposition

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[TAG d'extension de Length]
Payload           une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x34`, classe de lignée (`011`)
- Payload : Value intégré ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/))
- Nombre : plusieurs possibles

## Interprétation et validité

- Le format de digest est intégré comme Value afin de laisser la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'utilise que SHA-256.
