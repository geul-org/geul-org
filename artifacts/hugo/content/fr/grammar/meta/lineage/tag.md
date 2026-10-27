---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG est un Meta de lignée qui consigne un nom immuable attaché à une version (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne un nom immuable attaché à une version (git annotated tag).

## Disposition

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[TAG d'extension de Length]
nom               Value UTF8-TEXT-*
cible             Value SHA-256-DIGEST, ou marqueur d'omission 0x0000 (champ facultatif). Si omis : cette version
```

- Codec : Meta `0x39`, classe de lignée (`011`)
- Payload : Value intégré (texte + hachage du contenu facultatif)
- Nombre : plusieurs possibles

## Interprétation et validité

- Le nom est un [UTF8-TEXT](/fr/grammar/value/text/utf8-text/), la cible un [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/).
- Si la cible est omise (ABSENT `0x0000`, champ facultatif de [CODEC](/fr/grammar/edge/codec/)), le nom est attaché au document lui-même. Un document ne peut pas écrire en lui-même son propre hachage du contenu. La spécification geul.org `0x1839` comporte deux champs-enregistrements : name (`0840`, `0841`) et target (`0861`, `0000`).
- Un même nom n'est pas réutilisé pour une autre version.

## Exemple

- Nom `v1`, cette version : `19B9 08C0 7631 0000`

## Problèmes ouverts

- Alors qu'il existe un ID de version (numéro d'ordre), TAG est-il nécessaire ; répartition des rôles avec le nom de document (`BIND`).
