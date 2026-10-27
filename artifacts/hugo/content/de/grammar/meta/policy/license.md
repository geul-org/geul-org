---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE ist ein Richtlinien-Meta, das die Lizenz dieses Dokuments und der in der Bytefolge enthaltenen Werke festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Lizenz dieses Dokuments und der in der Bytefolge enthaltenen Werke fest.

## Layout

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length-Erweiterungs-TAG]
Payload           Reference auf die Lizenz, oder UTF8-TEXT mit SPDX-Kennung, oder URI-Value
```

- Codec: Meta `0x50`, Richtlinienklasse (`101`)
- Payload: eingebettetes Reference oder Value ([UTF8-TEXT](/de/grammar/value/text/utf8-text/), [URI](/de/grammar/value/text/uri/))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit

- Bei geul.org veröffentlichte Dokumente stehen unter CC0. Bei privater Veröffentlichung legt der Issuer die Lizenz fest ([Issuer](/de/grammar/issuer/)).
- Die ursprüngliche Lizenz des Ausgangswerks wird festgehalten.

## Offene Fragen

- Ob die SPDX-Kennung als Text oder als Reference auf eine GEUL-Entität abgelegt wird.
