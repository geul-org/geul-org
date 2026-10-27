---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER est une Reference de pointeur-déclaration qui cite, en un seul enregistrement et sans IMPORT, le LOCAL ID d'un document publié par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER est une Reference de pointeur-déclaration qui cite sans IMPORT le LOCAL ID d'un document publié par un Issuer. Un seul enregistrement suffit à lui donner son sens, et il suit la dernière version.

## Disposition

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[TAG d'extension de Length]
Issuer            largeur fixée par WW (00=1, 01=2, 10=4, 11=16 WORD)
ID de document    4 WORD
ID de cible       tout le reste. LOCAL ID de ce document, sur la largeur la plus courte
```

| CCCC | Nom | Largeur de l'Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (attribué par geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (enregistré par geul.org, preuve de domaine) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (enregistré par geul.org, sans preuve) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculé à partir de la clé publique) |

- L'ID d'Issuer est une valeur entière. Une même valeur désigne le même Issuer. On écrit l'Issuer sur la largeur la plus courte qui contienne la valeur et l'on choisit le Codec de cette largeur (2 WORD seulement si la valeur dépasse `0xFFFF`, 4 WORD seulement à partir de `2^32`, 16 WORD seulement à partir de `2^64`). La notation sur une largeur plus grande est invalid ([Issuer](/fr/grammar/issuer/)).
- L'enregistrement et la gestion des Issuer relèvent de geul.org.
- La version n'est pas indiquée et l'on suit la dernière version. Pour figer la version, on emploie [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) et [EXTERNAL-POINTER](/fr/grammar/reference/external-pointer/).
- L'emplacement se trouve par les règles d'adresse de publication ([Adresse de publication et liste des versions](/fr/grammar/publishing/)).
- Un même LOCAL ID de ce document est la même cible, qu'on l'écrive en LOCAL dans ce document, en EXTERNAL-ISSUER dans un autre document (ou en EXTERNAL-POINTER après IMPORT).
- Il ne désigne que des LOCAL du document. Le document lui-même se désigne par [DOC-POINTER](/fr/grammar/reference/doc-pointer/), l'Issuer lui-même par [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/). L'ID de cible n'est donc pas `0`. L'ID de document `0` est le document d'index des définitions de termes de l'Issuer.

## Validité

- Si la largeur de l'Issuer ne correspond pas au Codec, ou si la valeur tient dans une largeur plus étroite, invalid.
- Si l'ID de cible vaut `0`, invalid. L'ID de cible `0` (le document lui-même) relève de DOC-POINTER.
- Un WORD `0x0000` de tête est interdit dans l'ID de cible.

## Exemple

| Cible | Suite de WORD |
|---|---|
| Issuer `0x0001`, document `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, document `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Pages liées

- [Reference](/fr/grammar/reference/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/), [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/fr/grammar/reference/external-pointer/)
- [Issuer et publication](/fr/grammar/issuer/)
