---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "La clase IMPORT de Meta (3 bits superiores `110`, `0x60`~`0x6F`) trae documentos externos con un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase IMPORT de Meta (3 bits superiores `110`, Codec `0x60`~`0x6F`) trae documentos externos con un IMPORT ID. El Codec es solo `IMPORT-DOC` (`0x60`).

- IMPORT solo trae documentos. Los objetos del documento importado se señalan con el Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) del BODY ([Reference](/es/grammar/reference/)).
- Si se anota el ID de versión, queda ligado a esa edición, y si es `0`, a la edición más reciente en el momento de la interpretación. Los documentos publicados anotan la versión.
- El HEAD del documento importado no se trae. Los registros Reference y Value no se traen sino que se copian.
