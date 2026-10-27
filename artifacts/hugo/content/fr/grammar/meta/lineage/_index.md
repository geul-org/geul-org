---
title: "Meta — Lignée"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "La classe Meta de lignée (3 bits de poids fort `011`, `0x30` à `0x3F`) consigne, selon le modèle des commits git, d'où provient un document et comment il a été obtenu."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de lignée (3 bits de poids fort `011`, Codec `0x30` à `0x3F`) consigne d'où provient un document et comment il a été obtenu. La lignée suit le modèle des commits git ; l'unité correspondant à un commit est le document.

- Le **hachage du contenu** désigne le contenu d'un document entier (équivalent de l'id de commit git). C'est le SHA-256 allant de l'enregistrement d'ouverture (`DOC-*`) jusqu'à juste avant `END`, les enregistrements de la classe de vérification (`100`) étant exclus du calcul.
- L'**ID de version** est un entier de 2 WORD numéroté à partir de 1 dans l'ordre de publication, au sein d'un document nommé. `0` signifie qu'aucune version n'est indiquée.
- Les Meta de lignée désignent une version par son hachage du contenu. Le `PARENT` contenu dans un document entre lui aussi dans le hachage ; le hachage du contenu forme donc une chaîne de hachages reliant tout l'historique.
- L'historique n'est jamais effacé. Une correction est publiée comme nouvelle version. Les pointeurs mobiles, comme les branches, ne sont pas placés dans le document.
- `DELTA-BASE` et `DELTA-REMOVE` sont un format qui stocke une version sous forme de diff par rapport à une version de base. Une version est toujours définie comme un instantané.

Les règles de révision sont décrites dans [Document](/fr/grammar/document/).
