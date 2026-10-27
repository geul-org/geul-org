---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "A classe IMPORT do Meta (3 bits superiores `110`, `0x60`~`0x6F`) importa um documento externo por IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe IMPORT do Meta (3 bits superiores `110`, Codec `0x60`~`0x6F`) importa um documento externo por IMPORT ID. O Codec é um só, `IMPORT-DOC` (`0x60`).

- O IMPORT importa só documentos. Os alvos dentro do documento importado são apontados no BODY pela Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](/pt/grammar/reference/)).
- Se o ID da versão for escrito, vincula-se a essa edição; se for `0`, à edição mais recente no momento da interpretação. Os documentos publicados escrevem a versão.
- O HEAD do documento importado não é importado. Registros Reference e Value não são importados: são copiados.
