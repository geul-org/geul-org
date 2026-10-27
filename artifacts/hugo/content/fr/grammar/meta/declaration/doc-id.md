---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID est un Meta de définition qui déclare l'identifiant du document par un DOC-POINTER (Issuer, ID de document, version 0) désignant le document lui-même."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare l'identifiant de ce document. Il est nécessaire pour que d'autres documents puissent désigner ce document et les cibles qu'il contient.

## Disposition

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[TAG d'extension de Length]
document          enregistrement Reference DOC-POINTER. (Issuer, ID de document, version 0)
```

- Codec : Meta `0x12`, classe de définition (`001`)
- Payload : un Reference intégré [DOC-POINTER](/fr/grammar/reference/doc-pointer/) (Issuer, ID de document, version 0)
- Nombre : au plus un. Obligatoire pour un document dont le nom commence par `0x`

## Interprétation et validité

- Le Payload est exactement un enregistrement Reference `DOC-POINTER` (Issuer, ID de document, version `0`). Seul `0` est utilisé comme ID de version : la version est attribuée par la liste de versions, non par le document. Le Quantifier est `000`.
- La notation qui désigne « ce document » est donc la même dans DOC-ID, dans le Subject du [BIND](/fr/grammar/edge/bind/) de `documents.geul` et dans les citations d'autres documents.
- Un même document a le même `DOC-ID` quelle que soit la version. L'ID de version et le hachage du contenu ne sont pas écrits dans le document ([Version](/fr/grammar/document/#versions)).
- Le nom d'adresse est pris en charge par le `BIND` descriptif de l'index de noms `documents.geul` ([Adresses de publication et listes de versions](/fr/grammar/publishing/#nom-du-document)), et le titre lisible par le [LABEL](/fr/grammar/edge/label/) descriptif.
- S'il est absent, le document est anonyme et ne peut être désigné que par son hachage du contenu. Il est nécessaire pour qu'un autre document puisse désigner un LOCAL de ce document par un Reference de pointage.
- Le côté qui récupère un document vérifie que le `DOC-ID` du document reçu correspond à l'Issuer et à l'ID de document demandés.
- L'ID de document `0x0000000000000000` est le document d'index des définitions de termes de l'Issuer ([Issuer](/fr/grammar/issuer/)). Son nom commençant lui aussi par `0x`, il comporte un DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). L'Issuer lui-même est représenté par [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/).
- Pour les documents de `.well-known/geul/` dont le nom commence par `0x` (documents de version `<ID de version>.geul`, documents de spécification), le `DOC-ID` est obligatoire.
- Les documents dont le nom ne commence pas par `0x` n'ont, par exception, pas de `DOC-ID` : la liste de versions `versions.geul` ([PUBLICATION](/fr/grammar/edge/publication/)), l'index de noms de documents `documents.geul` et l'index de noms d'Issuers `issuers.geul` ([Adresses de publication et listes de versions](/fr/grammar/publishing/)). Le dépôt par hachage du contenu `h/` contient des copies de ces documents et suit donc les originaux.
- Les documents de spécification de Codec sont des documents de l'Issuer GEUL `0x0000`. L'ID de document est le TAG WORD Kind·Codec étendu à 4 WORD (`0x1018` → `0x0000000000001018`). Le Reference `0000` étant réservé, l'ID de document ne peut pas valoir `0` ([Documents de spécification](/fr/grammar/codec-spec/)).

## Exemple

- Issuer `0x0001`, document `0x…0005` : `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG Meta 1 + TAG Reference 1 + Issuer 1 + ID de document 4 + version 2 = 9 WORD)
