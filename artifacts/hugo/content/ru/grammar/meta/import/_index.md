---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Класс IMPORT в Meta (старшие 3 бита `110`, `0x60`~`0x6F`) импортирует внешний документ под IMPORT ID."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Класс IMPORT в Meta (старшие 3 бита `110`, Codec `0x60`~`0x6F`) импортирует внешний документ под IMPORT ID. Codec один -- `IMPORT-DOC` (`0x60`).

- IMPORT импортирует только документы. Объект внутри импортированного документа указывается в BODY через Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](/ru/grammar/reference/)).
- Если указан ID версии, привязка идёт к этой редакции, а при `0` -- к последней редакции на момент интерпретации. Опубликованные документы указывают версию.
- HEAD импортированного документа не импортируется. Записи Reference и Value не импортируются, а копируются.
