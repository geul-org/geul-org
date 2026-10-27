---
title: "Meta — procedencia"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "La clase de procedencia de Meta (3 bits superiores `010`, `0x20`~`0x2F`) anota quién creó y registró el documento y cuándo. El material de origen se escribe con el Edge de fundamento SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase de procedencia de Meta (3 bits superiores `010`, Codec `0x20`~`0x2F`) anota quién creó y registró el documento y cuándo.

- El autor y quien registra, y sus momentos, siguen el modelo author y committer de git (`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- Aunque se borre la procedencia, el contenido de las afirmaciones no cambia. Solo desaparece la materia prima del juicio de confianza.
- El material de origen no está en esta clase. La fuente del documento entero se escribe en el HEAD, y la de cada registro en el BODY, con el Edge de fundamento [SOURCE](/es/grammar/edge/source/). El rango correspondiente dentro del texto original, el momento de obtención y el hash del texto original son QUALIFIER que se añaden a ese SOURCE (página P304 · sección P958, fecha de consulta P813, checksum P4092).
- Si las propiedades que dependen de la fuente (rango del texto original, momento de obtención) se pusieran como Meta, cuando hay varias fuentes no se podría decidir de cuál son. Por eso se escriben con un QUALIFIER que tiene el SOURCE como Target. Los Codec `0x26`~`0x2F` están reservados.
