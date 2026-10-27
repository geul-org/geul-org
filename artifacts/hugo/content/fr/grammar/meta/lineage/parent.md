---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT est un Meta de lignée qui consigne le hachage du contenu de la version précédente (git parent). S'il y en a plusieurs, c'est une fusion."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le hachage du contenu de la version précédente (git parent).

## Disposition

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[TAG d'extension de Length]
Payload           une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x30`, classe de lignée (`011`)
- Payload : Value intégré ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/))
- Nombre : plusieurs possibles (fusion)

## Interprétation et validité

- S'il est absent, c'est la première version ; s'il y en a plusieurs, c'est une fusion (git merge commit).
- Il entre dans le [hachage du contenu](/fr/grammar/document/#hachage-du-contenu) ; tout l'historique forme donc une chaîne de hachages.
- Un document de liste de versions désigne le document de liste précédent ([PUBLICATION](/fr/grammar/edge/publication/)).
- Le format de digest est intégré comme Value afin de laisser la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'utilise que SHA-256.

## Exemple

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta de 20 WORD = TAG + extension de Length + Value intégré de 18 WORD)
