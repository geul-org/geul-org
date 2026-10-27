---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE est un Meta de définition qui déclare, par un texte de nom et de version, le profil appliqué au document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare le profil appliqué au document. Les mêmes enregistrements sont interprétés selon les documents de Codec définis par le profil (par exemple, avec `tangeul-1.0`, [TOULMIN](/fr/grammar/edge/toulmin/)).

## Disposition

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[TAG d'extension de Length]
Payload           Value UTF8-TEXT "<nom>-<major>.<minor>"
```

- Codec : Meta `0x11`, classe de définition (`001`)
- Payload : Value intégré ([UTF8-TEXT](/fr/grammar/value/text/utf8-text/))
- Nombre : au plus un

## Interprétation et validité

- Un profil dont le major diffère est rejeté. Une différence de minor est admise (changements additifs uniquement).
- Sans profil, le document se lit avec la seule grammaire de base de GEUL et les spécifications de codes directs.

## Exemple

- `tangeul-1.0` : `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Problèmes ouverts

- Registre des noms de profil (geul.org) et règles de nommage.
- Désigner le profil par un ID de document (IMPORT) ou le placer sous forme de texte.
