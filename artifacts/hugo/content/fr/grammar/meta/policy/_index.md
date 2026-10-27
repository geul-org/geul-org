---
title: "Meta — Politique"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "La classe Meta de politique (3 bits de poids fort `101`, `0x50` à `0x5F`) fixe le traitement du document : licence, étendue de diffusion, données personnelles, conservation, consentement, restrictions d'usage."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de politique (3 bits de poids fort `101`, Codec `0x50` à `0x5F`) fixe le traitement du document : licence, étendue de diffusion, niveau de données personnelles, durée de conservation, consentement et restrictions d'usage.

- Une politique ne modifie pas l'interprétation ; elle fixe la manière de traiter le document.
- La licence d'origine d'une œuvre contenue dans la suite d'octets est consignée par `LICENSE`.
