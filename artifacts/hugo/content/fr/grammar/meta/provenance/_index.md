---
title: "Meta — Source"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "La classe Meta de provenance (3 bits de poids fort `010`, `0x20` à `0x2F`) consigne qui a créé et enregistré le document, et quand. Les documents d'origine s'écrivent avec l'Edge de fondement SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de provenance (3 bits de poids fort `010`, Codec `0x20` à `0x2F`) consigne qui a créé et enregistré le document, et quand.

- L'auteur et l'enregistreur, ainsi que leurs instants, suivent le modèle author/committer de git (`AUTHOR`, `CREATED-AT`, `RECORDED-BY`, `RECORDED-AT`).
- Effacer la provenance ne change pas le contenu décrit. Seuls disparaissent les éléments du jugement de confiance.
- Cette classe ne contient pas la ressource d'origine. L'origine du document entier s'écrit dans le HEAD, celle d'un enregistrement individuel dans le BODY, toutes deux avec l'Edge de fondement [SOURCE](/fr/grammar/edge/source/). L'étendue correspondante dans le texte d'origine, l'instant d'acquisition et le hachage du texte d'origine sont des QUALIFIER joints à ce SOURCE (page P304, section P958, date de consultation P813, somme de contrôle P4092).
- Si l'on faisait des propriétés de l'origine (étendue dans le texte, instant d'acquisition) des Meta, on ne pourrait pas dire de quelle origine elles relèvent quand il y en a plusieurs. On les écrit donc comme QUALIFIER ayant le SOURCE pour Target. Les Codec `0x26` à `0x2F` sont réservés.
