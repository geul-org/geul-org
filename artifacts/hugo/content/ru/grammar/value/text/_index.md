---
title: "Value — текст"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Форматы семейства TEXT (Codec `0x40`–`0x5F`, номера форматов `0x8000`–`0xBFFF`): текст UTF-8, текст с языком, URI, коды языков."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Семейство TEXT — это форматы текста и строковых идентификаторов. Они занимают прямые коды `0x40`–`0x5F` и номера форматов Issuer `0x8000`–`0xBFFF`.

- Строка без языка — UTF8-TEXT, а текст с языком, такой как имя, заголовок или предложение, — UTF8-LANGUAGE-TEXT.
- Коды языков (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) тоже относятся к семейству TEXT.
- Последовательности байт переменной длины задаются парой чётного и нечётного Codec. Если младший бит равен `1`, число байт нечётное, а младший byte последнего WORD — padding `0x00` ([Запись и TAG WORD](/ru/grammar/record/)).
