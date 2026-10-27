---
title: "Value — texto"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Formatos de la familia TEXT (Codec `0x40`~`0x5F`, número de formato `0x8000`~`0xBFFF`): texto UTF-8, texto con idioma, URI y códigos de idioma."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La familia TEXT son formatos de texto e identificadores de cadena. Se colocan en los códigos directos `0x40`~`0x5F` y en los números de formato Issuer `0x8000`~`0xBFFF`.

- Una cadena sin idioma es UTF8-TEXT, y un texto con idioma, como nombres, títulos y frases, es UTF8-LANGUAGE-TEXT.
- Los códigos de idioma (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) también son de la familia TEXT.
- Los bytes de longitud variable se colocan en pares de Codec par/impar. Si el bit menos significativo es `1`, el número de bytes es impar y el byte inferior del último WORD es relleno `0x00` ([Registro y TAG WORD](/es/grammar/record/)).
