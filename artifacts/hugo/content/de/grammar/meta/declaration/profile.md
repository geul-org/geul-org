---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE ist ein Definitions-Meta, das das auf das Dokument angewandte Profil als Namen und Versionstext deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert das auf das Dokument angewandte Profil. Dieselben Records werden anhand der vom Profil bestimmten Codec-Dokumente interpretiert (z. B. bei `tangeul-1.0` als [TOULMIN](/de/grammar/edge/toulmin/)).

## Layout

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length-Erweiterungs-TAG]
Payload           UTF8-TEXT-Value "<Name>-<major>.<minor>"
```

- Codec: Meta `0x11`, Definitionsklasse (`001`)
- Payload: eingebetteter Value ([UTF8-TEXT](/de/grammar/value/text/utf8-text/))
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Profile mit abweichender major-Version werden abgelehnt. Unterschiede in der minor-Version sind erlaubt (nur additive Änderungen).
- Ohne Profil liest man nur mit der GEUL-Grundgrammatik und den Spezifikationen der direkten Codes.

## Beispiel

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Offene Fragen

- Profilnamen-Registry (geul.org) und Namensregeln.
- Ob man das Profil über eine Dokument-ID anspricht (IMPORT) oder als Text ablegt.
