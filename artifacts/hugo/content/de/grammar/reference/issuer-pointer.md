---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER ist ein Zeiger-Deklarations-Reference, das auf den Issuer selbst verweist. Der Payload besteht nur aus einem Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER ist ein Zeiger-Deklarations-Reference, das auf den Issuer selbst verweist. Es ist Ziel des Issuer-Namens-`BIND`, von `LABEL` und von Urteils-Edges.

## Layout

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length-Erweiterungs-TAG]
Issuer            1/2/4/16 WORD
```

- Die Issuer-Breite ist der gesamte Payload. Der Codec teilt die Breite nicht auf. Ist die Breite nicht 1, 2, 4 oder 16 WORD, oder passt der Issuer-Wert in eine schmalere Breite, ist es invalid (kanonische Form des Issuers).
- Bei einem 16-WORD-Issuer sind es insgesamt 17 WORD, sodass 1 WORD Length-Erweiterung hinzukommt.
- Als Quantifier wird nur `000` (Identified) verwendet. Andere Werte sind invalid.
- Der Issuer-Wert folgt der Vergabe nach [Issuer](/de/grammar/issuer/).
- Verwendung: Subject des BIND im Issuer-Namensindex `issuers.geul` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#issuer-name)), LABEL des Anzeigenamens des Issuers, Urteile über den Issuer, Signierende und andere Stellen, an denen der Issuer selbst Gegenstand ist.
- Das Format, das auf den Issuer selbst verweist, ist allein ISSUER-POINTER. Mit `EXTERNAL-ISSUER-*` mit Dokument-ID `0` und Ziel-ID `0` auf den Issuer zu verweisen ist invalid.

## Beispiel

| Issuer | WORD-Folge |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [DOC-POINTER](/de/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [Issuer und Veröffentlichung](/de/grammar/issuer/)
