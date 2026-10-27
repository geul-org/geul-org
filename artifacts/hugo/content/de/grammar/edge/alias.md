---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS ist ein Beschreibungs-Edge (Codec 0x05), das einen weiteren Namen (Alias) des Subject verbindet. Das Layout ist wie bei LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS ist ein Beschreibungs-Edge, das einen weiteren Namen (Alias) des Subject als Object verbindet. Codec `0x05`.

[LABEL](/de/grammar/edge/label/) ist der maßgebliche Name in dieser Sprache (höchstens einer je Sprache), ALIAS ein weiterer Name desselben Objekts (mehrere je Sprache, Wikidata „also known as“). Er dient vor allem der Suche. Layout und Gültigkeit sind wie bei LABEL.

## Layout

```
TAG WORD          0001 0LLL L000 0101
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            UTF8-LANGUAGE-TEXT-Value oder 1 LOCAL-Reference-Record
```

## Interpretation und Gültigkeit

- Die Regeln für Subject und Object sind wie bei [LABEL](/de/grammar/edge/label/) (das Object ist [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/) oder ein LOCAL, das darauf aufgelöst wird).
- Zu demselben Subject und derselben Sprache kann es mehrere ALIAS geben. Die Reihenfolge ist die Reihenfolge im Dokument.
- Derselbe Text wie das LABEL desselben Subject in derselben Sprache wird nicht als ALIAS angelegt (der maßgebliche Name genügt als ein LABEL). Diese Regel ist eine Empfehlung.
- Das geul.org-Spezifikationsdokument beschränkt das Object mit [CODEC](/de/grammar/edge/codec/) (`084A`, `084B`, `0008`, wie bei LABEL).

## Beispiel (nicht normativ)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): Sprache `08C6 656e` (BCP47 `en`) + Text 3 Byte (ungerade) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. Das TAG ist `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [LABEL](/de/grammar/edge/label/), [DESCRIPTION](/de/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/)
