---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER est une Reference de pointeur-déclaration qui désigne une version d'un document publié par un Issuer. L'ID de version 0 est la dernière version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER est une Reference de pointeur-déclaration qui désigne une version d'un document publié par un Issuer. Il est l'objet de la publication, de la dépréciation (deprecate) et de la suppression d'un document, de l'édition citée et des descriptions portant sur un document.

## Disposition

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[TAG d'extension de Length]
Issuer            1/2/4/16 WORD
ID de document    4 WORD
ID de version     2 WORD
```

## Interprétation et validité

- La largeur de l'Issuer est ce qui reste du Payload après les 6 WORD d'ID de document et d'ID de version. Le Codec ne divise pas la largeur. Si la largeur n'est pas de 1, 2, 4 ou 16 WORD, ou si la valeur de l'Issuer tient dans une largeur plus étroite, invalid (forme canonique de l'Issuer).
- L'ID de version ne s'omet pas. Si l'on admettait l'omission, la largeur de l'Issuer ne pourrait pas se déduire de la seule longueur du Payload (un Issuer de 4 WORD sans version et un Issuer de 2 WORD avec version feraient tous deux 8 WORD).
- L'ID de version `0` est la dernière version. Il est lié à l'édition en vigueur au moment de l'interprétation. Les autres valeurs sont figées sur cette version ([PUBLICATION](/fr/grammar/edge/publication/)).
- L'ID de document `0` est le document d'index des définitions de termes de l'Issuer. L'Issuer lui-même se désigne par [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/).
- Seul le Quantifier `000` (Identified) s'emploie. Toute autre valeur est invalid.
- Le seul format qui désigne un document d'un Issuer est DOC-POINTER. Désigner un document par `EXTERNAL-ISSUER-*` (Issuer, ID de document, ID de cible `0`) ou `EXTERNAL-POINTER-*` (IMPORT ID, ID de cible `0`) est invalid.
- Où on l'emploie : les Meta [DOC-ID](/fr/grammar/meta/declaration/doc-id/) et [IMPORT-DOC](/fr/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION et TOMBSTONE de la liste des versions et le Subject de BIND, le Subject de BIND de l'index des noms `documents.geul`.

## Exemple

Issuer GEUL `0x0000`, document `0xffff000000000001`.

| Version | Suite de WORD |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| Dernière (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ID de document 4 + ID de version 2 = 8 WORD, `LLLL=0111`. Le TAG est `0000 0 0111 0111 000` = `03B8`.

## Pages liées

- [Reference](/fr/grammar/reference/), [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/), [PUBLICATION](/fr/grammar/edge/publication/)
- [Issuer et publication](/fr/grammar/issuer/)
