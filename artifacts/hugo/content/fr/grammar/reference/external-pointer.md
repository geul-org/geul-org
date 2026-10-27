---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER est une Reference de pointeur qui désigne le LOCAL ID d'un document importé par IMPORT-DOC dans le HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER est une Reference de pointeur qui désigne le LOCAL ID d'un document importé par [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) dans le HEAD.

## Disposition

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[TAG d'extension de Length]
IMPORT ID         largeur fixée par WW (00=1, 01=2, 10=4, 11=8 WORD)
ID de cible       tout le reste. LOCAL ID du document importé, sur la largeur la plus courte
```

| CCCC | Nom | Largeur de l'IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- On emploie le Codec le plus étroit qui contienne la valeur de l'IMPORT ID.
- L'IMPORT ID est la valeur attribuée par l'`IMPORT-DOC` de ce document et ne vaut qu'à l'intérieur de ce document. EXTERNAL-POINTER n'écrit pas d'Issuer. L'Issuer et l'ID de document viennent de cet `IMPORT-DOC`. La version est elle aussi fixée par cet `IMPORT-DOC` (figée ou dernière).
- Un même LOCAL ID du document importé est la même cible, qu'on l'écrive en LOCAL dans ce document-là ou en EXTERNAL-POINTER ici.
- Si c'est une Variable, c'est une variable LOCAL du document importé.

## Validité

- S'il n'y a pas dans ce document d'`IMPORT-DOC` qui ait attribué cet IMPORT ID, invalid.
- Si l'IMPORT ID tient dans un Codec plus étroit mais qu'on emploie un Codec plus large, on rejette comme non minimal.
- Si l'ID de cible vaut `0`, invalid. Le document importé lui-même se désigne par [DOC-POINTER](/fr/grammar/reference/doc-pointer/).
- Un WORD `0x0000` de tête est interdit dans l'ID de cible.

## Exemple

| Cible | Suite de WORD |
|---|---|
| LOCAL 5 de l'IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 de l'IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 de l'IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Pages liées

- [Reference](/fr/grammar/reference/), [LOCAL](/fr/grammar/reference/local/), [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/fr/grammar/meta/import/import-doc/)
