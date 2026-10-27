---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "La classe Meta IMPORT (3 bits de poids fort `110`, `0x60` à `0x6F`) importe un document externe sous un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta IMPORT (3 bits de poids fort `110`, Codec `0x60` à `0x6F`) importe un document externe sous un IMPORT ID. Le seul Codec est `IMPORT-DOC` (`0x60`).

- IMPORT n'importe que des documents. Les cibles contenues dans le document importé sont désignées dans le BODY par le Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](/fr/grammar/reference/)).
- Si un ID de version est indiqué, l'import est lié à cette édition ; avec `0`, il est lié à l'édition la plus récente au moment de l'interprétation. Un document publié indique la version.
- Le HEAD du document importé n'est pas importé. Les enregistrements Reference et Value ne sont pas importés mais copiés.
