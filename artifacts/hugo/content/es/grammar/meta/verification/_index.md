---
title: "Meta — verificación"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "La clase de verificación de Meta (3 bits superiores `100`, `0x40`~`0x4F`) anota la materia prima para juzgar si el documento es de fiar (clave pública, firma, confiabilidad, juicio)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase de verificación de Meta (3 bits superiores `100`, Codec `0x40`~`0x4F`) anota la materia prima para juzgar si el documento es de fiar: la clave pública de un Issuer de autoemisión, la firma, la confirmación de derechos de contribución, la confiabilidad y el resultado del juicio del documento entero.

- La clase de verificación se excluye del cálculo del hash de contenido. Por eso, ni colocar la firma dentro del documento ni añadir varias firmas cambia el hash de contenido (igual que `gpgsig` de git).
- La clase se conoce por los 3 bits superiores del Codec, así que el hash se puede calcular sin libro de códigos.
- El juicio por nodo o por registro lo lleva el Edge `VERDICT` (`0x78`) de [TOULMIN](/es/grammar/edge/toulmin/).
