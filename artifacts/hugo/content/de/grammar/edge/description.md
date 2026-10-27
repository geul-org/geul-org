---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION ist ein Beschreibungs-Edge (Codec 0x06), das eine kurze Sprachbeschreibung des Subject verbindet. Das Layout ist wie bei LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION ist ein Beschreibungs-Edge, das eine Beschreibung des Subject in einer bestimmten Sprache als Object verbindet. Codec `0x06`.

Eine Beschreibung ist eine kurze Wendung, die das Objekt unterscheidbar macht (Wikidata description, z. B. „Hauptstadt und größte Stadt Deutschlands“). Sie ist keine Definition und keine Behauptung über das Objekt. Propositionen über das Objekt schreibt man als [TRIPLE](/de/grammar/edge/triple/). Das Layout ist wie bei [LABEL](/de/grammar/edge/label/). Beschreibung und Sprache stehen in einem einzigen Object, [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/). Es gibt kein Rohwert-Feld.

## Layout

```
TAG WORD          0001 0LLL L000 0110
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            UTF8-LANGUAGE-TEXT-Value oder 1 LOCAL-Reference-Record
```

## Interpretation und Gültigkeit

- Die Regeln für Subject und Object sind wie bei [LABEL](/de/grammar/edge/label/). Das Subject ist genau ein vollständiger Reference-Record. Das Object ist genau ein vollständiger UTF8-LANGUAGE-TEXT-Record (`0x4A`/`0x4B`) oder ein LOCAL Reference, das über eine [REFERENCE-NODE](/de/grammar/edge/reference-node/)-Bindung im selben Dokument auf UTF8-LANGUAGE-TEXT aufgelöst wird.
- Text ohne Sprache (UTF8-TEXT) kann keine DESCRIPTION sein. Eine Beschreibung gibt es je Sprache nur eine, daher gilt diese Regel nur mit Sprache. Beschreibungen, die mehreren Sprachen gemeinsam sind, schreibt man mit der Sprache `mul`.
- Zu demselben Subject und derselben Sprache gibt es höchstens eine DESCRIPTION.
- Die Beschreibung dient dazu, von gleichnamigen anderen Objekten zu unterscheiden. Es ist wünschenswert, dass sich das Paar aus LABEL und DESCRIPTION in derselben Sprache bei zwei Objekten nicht überschneidet, aber die Spezifikation prüft das nicht (auch Wikidata empfiehlt es nur und erzwingt es nicht).
- Das geul.org-Spezifikationsdokument beschränkt das Object mit [CODEC](/de/grammar/edge/codec/) (`084A`, `084B`, `0008`, wie bei LABEL).

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

- Sprach-Record und Textbytezahl des Object verantwortet der Object-Record. Der Cursor nach dem Lesen des letzten Records muss genau mit dem Ende des Edge übereinstimmen.
- Beschreibungen sind länger als Labels, sodass Object und Edge leicht 15 WORD überschreiten. Dann verwendet man die Length-Erweiterung ([Record](/de/grammar/record/)).

## Beispiel (nicht normativ)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). Da das Sprachregister noch fehlt, ist die Sprache LANGUAGE-BCP47-CODE.

- Das Object besteht aus der Sprache `08C6 656E` (BCP47 `en`, 2 WORD) + Text 35 Byte (ungerade, 18 WORD), also `0x4B`, TAG 1 + Erweiterungs-TAG 1 + 20 = 22 WORD, `0F4B 0016 …`.
- Das Edge hat TAG 1 + Erweiterungs-TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, also `LLLL=1110`, TAG `1706`, Erweiterungs-TAG `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Entsprechung in Wikidata

- Die `descriptions` eines Eintrags (eine je Sprache) → ein DESCRIPTION je Sprache. Die Sprachcodes werden mit derselben Sprachcode-Zuordnungstabelle wie bei LABEL übertragen.

## Offene Fragen

- Ob es Fälle gibt, in denen eine Beschreibung aus UTF8-TEXT ohne Sprache zugelassen werden sollte (derzeit nicht zugelassen).

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [LABEL](/de/grammar/edge/label/), [ALIAS](/de/grammar/edge/alias/), [CODEC](/de/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/), [LOCAL](/de/grammar/reference/local/), [REFERENCE-NODE](/de/grammar/edge/reference-node/)
