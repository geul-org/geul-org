---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER est une Reference de pointeur-déclaration qui désigne l'Issuer lui-même. Le Payload se réduit à l'Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER est une Reference de pointeur-déclaration qui désigne l'Issuer lui-même. Il est la cible du `BIND` de nom d'Issuer, de `LABEL` et des Edge de jugement.

## Disposition

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[TAG d'extension de Length]
Issuer            1/2/4/16 WORD
```

- La largeur de l'Issuer est tout le Payload. Le Codec ne divise pas la largeur. Si la largeur n'est pas de 1, 2, 4 ou 16 WORD, ou si la valeur de l'Issuer tient dans une largeur plus étroite, invalid (forme canonique de l'Issuer).
- Si l'Issuer fait 16 WORD, le total est de 17 WORD, d'où 1 WORD d'extension de Length.
- Seul le Quantifier `000` (Identified) s'emploie. Toute autre valeur est invalid.
- La valeur de l'Issuer suit l'attribution de [Issuer](/fr/grammar/issuer/).
- Usages : Subject de BIND de l'index des noms d'Issuer `issuers.geul` ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-dissuer)), LABEL du nom d'affichage de l'Issuer, jugement sur l'Issuer, signataire, et autres places où l'Issuer lui-même est la cible.
- Le seul format qui désigne l'Issuer lui-même est ISSUER-POINTER. Désigner l'Issuer par `EXTERNAL-ISSUER-*` avec ID de document `0` et ID de cible `0` est invalid.

## Exemple

| Issuer | Suite de WORD |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Pages liées

- [Reference](/fr/grammar/reference/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/), [Issuer et publication](/fr/grammar/issuer/)
