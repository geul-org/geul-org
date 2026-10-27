---
title: "Value — Texte"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Formats de la famille TEXT (Codec `0x40`~`0x5F`, numéros de format `0x8000`~`0xBFFF`) : texte UTF-8, texte accompagné d'une langue, URI, codes de langue."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La famille TEXT regroupe les formats de texte et d'identifiants en chaîne. Elle se place dans les codes directs `0x40`~`0x5F` et les numéros de format d'Issuer `0x8000`~`0xBFFF`.

- Une chaîne sans langue est UTF8-TEXT ; un texte avec langue comme nom, titre ou phrase est UTF8-LANGUAGE-TEXT.
- Les codes de langue (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) sont eux aussi de la famille TEXT.
- Les suites d'octets de longueur variable se placent par paires de Codec pair/impair. Si le bit de poids faible vaut `1`, le nombre d'octets est impair et l'octet de poids faible du dernier WORD est un remplissage `0x00` ([Enregistrement et TAG WORD](/fr/grammar/record/)).
