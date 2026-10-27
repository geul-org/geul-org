---
title: "Value — Text"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Die Formate der TEXT-Familie (Codec `0x40`~`0x5F`, Formatnummern `0x8000`~`0xBFFF`): UTF-8-Text, Text mit Sprache, URI, Sprachcodes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die TEXT-Familie umfasst Formate für Text und Zeichenkettenkennungen. Sie liegen bei den direkten Codes `0x40`~`0x5F` und den Issuer-Formatnummern `0x8000`~`0xBFFF`.

- Eine Zeichenkette ohne Sprache ist UTF8-TEXT, ein Text mit Sprache wie Name, Titel und Satz ist UTF8-LANGUAGE-TEXT.
- Auch Sprachcodes (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) gehören zur TEXT-Familie.
- Bytefolgen variabler Länge liegen als Codec-Paare aus gerade/ungerade vor. Ist das niederwertigste Bit `1`, ist die Bytezahl ungerade, und das untere Byte des letzten WORD ist ein Padding `0x00` ([Record und TAG WORD](/de/grammar/record/)).
