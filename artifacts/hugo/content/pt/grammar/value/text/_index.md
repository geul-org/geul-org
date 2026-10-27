---
title: "Value — Texto"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Formatos da família TEXT (Codec `0x40`~`0x5F`, números de formato `0x8000`~`0xBFFF`): texto UTF-8, texto com idioma, URI e códigos de idioma."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A família TEXT são formatos de texto e de identificadores em cadeia de caracteres. Ficam nos códigos diretos `0x40`~`0x5F` e nos números de formato Issuer `0x8000`~`0xBFFF`.

- Uma cadeia sem idioma é UTF8-TEXT, e um texto com idioma, como nomes, títulos e frases, é UTF8-LANGUAGE-TEXT.
- Os códigos de idioma (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) também são da família TEXT.
- As sequências de bytes de comprimento variável ficam em pares de Codecs par/ímpar. Se o bit menos significativo é `1`, o número de bytes é ímpar e o byte inferior da última WORD é um padding `0x00` ([Registro e TAG WORD](/pt/grammar/record/)).
