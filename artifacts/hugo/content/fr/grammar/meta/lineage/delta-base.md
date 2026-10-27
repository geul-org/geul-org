---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE est un Meta de lignée qui indique que ce fichier de version est un diff par rapport à une version de base du même document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Marque ce fichier de version comme un **diff** par rapport à une version de base du même document, et non comme un instantané (delta d'un packfile git). La version elle-même reste définie comme un instantané. Le hachage du contenu, la liste de versions et les signatures portent tous sur l'instantané restauré par application du diff ([Stockage par diff](/fr/grammar/document/#stockage-du-diff)).

## Disposition

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
ID de version     2 WORD non signés (version de base du même document)
```

- Codec : Meta `0x3A`, classe de lignée (`011`)
- Payload : ID de version de 2 WORD (valeur brute)
- Nombre : au plus un

## Interprétation et validité

- Ne s'utilise que dans les documents qui ont un [DOC-ID](/fr/grammar/meta/declaration/doc-id/) (documents dont les versions sont gérées par une liste de versions). `versions.geul`, `documents.geul` et `issuers.geul`, qui n'ont pas de gestion de versions, ainsi que les documents anonymes, n'ont pas de diff.
- La version de base est une version publiée du même `DOC-ID` et antérieure à cette version. `0` (pas de version) est invalid.
- Le hachage du contenu de l'instantané restauré doit être égal au hachage de cette version dans la liste de versions ([PUBLICATION](/fr/grammar/edge/publication/)). Sinon, ce diff est invalid. C'est pourquoi le hachage résultant n'est pas écrit séparément dans le diff.
- Seul un document dont tous les enregistrements du BODY sont des Edge (enregistrements ayant un Edge Id) peut être stocké en diff, car l'unité du diff est le LOCAL ID (Edge Id).
- Les règles de restauration de l'instantané suivent [Stockage par diff](/fr/grammar/document/#stockage-du-diff). La suppression relève de [DELTA-REMOVE](/fr/grammar/meta/lineage/delta-remove/).
- Il n'y a pas de marqueur distinct d'ajout ou de révision. Si l'Edge Id d'un diff BODY existe dans la base, c'est une révision ; sinon, c'est un ajout. Un ajout reçoit son numéro à partir de [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/) de la liste de versions. Réutiliser un LOCAL ID supprimé est invalid ([Révision](/fr/grammar/document/#révision)).

## Exemple

Diff par rapport à la version de base 3 :

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), ID de version `0000 0003`.

## Problèmes ouverts

1. Intervalle entre instantanés : tous les combien de versions placer un instantané complet (longueur de la chaîne de diffs et coût de restauration).
2. Limiter ou non la version de base à la version précédente.
3. Lieu de stockage du fichier diff : à l'emplacement du fichier de version (`<ID de version>.geul`) ou en relation avec le dépôt adressé par contenu `h/` (`h/` se retrouve par le hachage du contenu de l'instantané).
