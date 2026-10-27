---
title: "Meta — Vérification"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "La classe Meta de vérification (3 bits de poids fort `100`, `0x40` à `0x4F`) consigne les éléments permettant de juger si un document est digne de confiance (clé publique, signature, fiabilité, verdict)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de vérification (3 bits de poids fort `100`, Codec `0x40` à `0x4F`) consigne les éléments permettant de juger si un document est digne de confiance : clé publique d'un Issuer auto-émis, signature, confirmation du droit de contribuer, fiabilité et verdict sur l'ensemble du document.

- La classe de vérification est exclue du calcul du hachage du contenu. Ainsi, le hachage ne change ni lorsqu'une signature est placée dans le document, ni lorsqu'on en ajoute plusieurs (même principe que le `gpgsig` de git).
- La classe se reconnaît aux 3 bits de poids fort du Codec, ce qui permet de calculer le hachage sans codebook.
- Le verdict au niveau d'un nœud ou d'un enregistrement relève de l'Edge `VERDICT` (`0x78`) de [TOULMIN](/fr/grammar/edge/toulmin/).
