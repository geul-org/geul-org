---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC est un Meta IMPORT qui désigne un document externe par un DOC-POINTER et lui attribue un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Importe un document externe sous un IMPORT ID. Le document à importer est désigné par un [DOC-POINTER](/fr/grammar/reference/doc-pointer/), qui porte aussi la largeur de l'Issuer.

## Disposition

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[TAG d'extension de Length]
document          enregistrement Reference DOC-POINTER (Issuer, ID de document, ID de version. Version 0 = la plus récente)
IMPORT ID         tout le reste. Non signé de la largeur la plus courte
```

- Codec : Meta `0x60`, classe IMPORT (`110`)
- Payload : Reference intégré `DOC-POINTER` (Issuer, ID de document, ID de version) + valeur brute de l'IMPORT ID
- Nombre : plusieurs possibles (un par IMPORT ID)

## Interprétation et validité

- Le document est exactement un enregistrement DOC-POINTER. Il se termine par sa propre Length ; le reste est l'IMPORT ID.
- L'IMPORT ID fait 1 WORD ou plus, de la largeur la plus courte. Sa largeur est déterminée ici par la longueur de l'enregistrement, et dans [EXTERNAL-POINTER-*](/fr/grammar/reference/external-pointer/) par le Codec. Un IMPORT ID n'est valide qu'à l'intérieur de ce document.
- Un même IMPORT ID n'est pas attribué deux fois dans un document.
- Si un ID de version est indiqué, l'import est lié à cette édition ; avec `0`, il est lié à l'édition la plus récente au moment de l'interprétation (ou à celle en vigueur à l'instant indiqué) ([Révision](/fr/grammar/document/#révision)).
- Les [EXTERNAL-POINTER-*](/fr/grammar/reference/external-pointer/) du BODY désignent un LOCAL du document importé via l'IMPORT ID. Le document importé lui-même est désigné par DOC-POINTER.
- Le HEAD du document importé n'est pas importé. Les cibles de ce document sont interprétées selon les déclarations de ce document.
- Un IMPORT ID ne permet pas de rechercher à travers les documents. Un dépôt qui charge plusieurs documents stocke l'IMPORT ID résolu en chemin complet (Issuer, ID de document, ID de version, LOCAL ID).

## Exemple

- IMPORT ID 1, Issuer `0x0001`, document `0x…0002`, la plus récente : `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
