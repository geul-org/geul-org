---
title: "Meta — Définition"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "La classe Meta de définition (3 bits de poids fort `001`, `0x10` à `0x1F`) regroupe les déclarations d'interprétation : édition de la spécification, profil, ID de document, période d'entrée en vigueur, langue par défaut."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de définition (3 bits de poids fort `001`, Codec `0x10` à `0x1F`) regroupe les déclarations d'interprétation. Une déclaration modifie les règles d'interprétation, tous les décodeurs doivent donc la traiter. Sa portée est le document qui la contient.

- `SPEC-VERSION` détermine comment lire les autres enregistrements ; il ne contient donc qu'un entier, sans Value intégré. GEUL v1 vaut `0x0001` (enregistrement `1890 0001`).
- `DOC-ID` est le `DOC-POINTER` (Issuer, ID de document, version `0`) qui désigne le document lui-même. S'il est absent, le document est anonyme et ne peut être désigné que par son hachage du contenu.
- Le nom d'adresse d'un document n'est pas un Meta. L'index de noms `documents.geul` de l'Issuer l'attache par un `BIND` descriptif, et le titre lisible par un `LABEL` ([Adresses de publication et listes de versions](/fr/grammar/publishing/#nom-du-document)).
