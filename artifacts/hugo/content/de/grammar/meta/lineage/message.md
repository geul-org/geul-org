---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE ist ein Abstammungs-Meta, das den Grund einer Änderung als Text mit Sprachangabe festhält (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält den Grund der Änderung fest (git commit message).

## Layout

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length-Erweiterungs-TAG]
Nachricht         1 UTF8-LANGUAGE-TEXT-Value
```

- Codec: Meta `0x38`, Abstammungsklasse (`011`)
- Payload: eingebetteter Value ([UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/))
- Anzahl: höchstens eins je Sprache

## Interpretation und Gültigkeit

- Nachricht und Sprache stehen in einem UTF8-LANGUAGE-TEXT. Es gibt nur ein MESSAGE je Sprache.
- Die geul.org-Spezifikationsdokumente schreiben es mit [CODEC](/de/grammar/edge/codec/) `084A` und `084B`.
