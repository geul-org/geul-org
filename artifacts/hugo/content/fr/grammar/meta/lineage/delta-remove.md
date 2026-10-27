---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE est un Meta de lignée qui consigne, dans un diff, la liste des LOCAL ID (Edge Id) à retirer du BODY de l'instantané de base."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Dans un diff ([DELTA-BASE](/fr/grammar/meta/lineage/delta-base/)), consigne les LOCAL ID (Edge Id) des enregistrements à retirer du BODY de l'instantané de base (« article X supprimé »).

## Disposition

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[TAG d'extension de Length]
LOCAL ID à supprimer    enregistrements Reference LOCAL × 1 ou plus
```

- Codec : Meta `0x3B`, classe de lignée (`011`)
- Payload : un ou plusieurs enregistrements Reference [LOCAL](/fr/grammar/reference/local/)
- Nombre : au plus un

## Interprétation et validité

- Ne se place que dans un document ayant `DELTA-BASE`.
- Chaque LOCAL ID doit être un Edge Id présent dans le BODY de l'instantané de base. Sinon, invalid. Placer deux fois le même ID est invalid.
- Replacer le même Edge Id dans le BODY du même diff est invalid (suppression et révision ne peuvent pas être combinées).
- Un LOCAL ID supprimé n'est pas réattribué à une autre cible dans les versions suivantes ([Révision](/fr/grammar/document/#révision)).
- L'absence d'un enregistrement dans le BODY du diff signifie « inchangé ». La suppression ne s'exprime donc que par ce Meta.
- Les Edge du HEAD (le [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du document entier et ses QUALIFIER) ne s'y consignent pas. Le HEAD est remplacé en bloc par le HEAD du diff ([Stockage du diff](/fr/grammar/document/#stockage-du-diff)).

## Exemple

Suppression des LOCAL `#7` et `#12` :

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), Reference LOCAL `0088 0007`, `0088 000C`.
