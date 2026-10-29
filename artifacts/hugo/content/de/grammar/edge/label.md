---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL ist ein Beschreibungs-Edge (Codec 0x04), das einen Sprachnamen des Subject mit einem UTF8-LANGUAGE-TEXT-Object verbindet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL ist ein Beschreibungs-Edge, das einen Namen (label) des Subject in einer bestimmten Sprache als Object verbindet. Codec `0x04`. Es ist kein Edge, der das Lemma der allgemeinen Lexikologie darstellt.

Name und Sprache stehen in einem einzigen Object, [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/). Es gibt kein Rohwert-Feld.

## Layout

```
TAG WORD          0001 0LLL L000 0100
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            UTF8-LANGUAGE-TEXT-Value oder 1 LOCAL-Reference-Record
```

## Interpretation und Gültigkeit

- Das Subject ist genau ein vollständiger Reference-Record. Seine Grenze findet man über seine eigene Length; ist es kein Reference oder unvollständig, ist es invalid.
- Das Object ist genau ein vollständiger [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/)-Record (`0x4A`/`0x4B`). Die Regeln für Sprache und Text (beide Sprachformate zulässig, Vergleich derselben Sprache) richten sich nach diesem Format.
- Das Object kann auch ein LOCAL Reference sein. Dann muss es über eine [REFERENCE-NODE](/de/grammar/edge/reference-node/)-Bindung im selben Dokument auf UTF8-LANGUAGE-TEXT aufgelöst werden. Wird es nicht aufgelöst oder auf ein anderes Objekt aufgelöst, ist es invalid.
- Das geul.org-Spezifikationsdokument schreibt diese Beschränkung mit [CODEC](/de/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). Das Auflösungsziel von LOCAL wird nicht mit CODEC ausgedrückt.
- Ist das Object keines der beiden obigen Formate oder der Record unvollständig, ist es invalid. Text ohne Sprache (UTF8-TEXT) kann kein LABEL sein. Maschinennamen ohne Sprache schreibt man als [BIND](/de/grammar/edge/bind/). Namen, die mehreren Sprachen gemeinsam sind, schreibt man mit der Sprache `mul`.
- Zu demselben Subject und derselben Sprache gibt es höchstens ein LABEL. Weitere Namen schreibt man als [ALIAS](/de/grammar/edge/alias/).

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

- Sprach-Record und Textbytezahl des Object verantwortet nicht das Edge, sondern der Object-Record. Der Cursor nach dem Lesen des letzten Records muss genau mit dem Ende des Edge übereinstimmen.

## Beispiel (nicht normativ)

Der Sprachcode `0784` für `en` ist die Nummer in der GEUL Language Registry v2 (Spezifikationsdokument `0x0000/0x0000000000000848` Version 2).

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Das Object besteht aus der Sprache `08C8 0784` (SHORT-CODE 2 WORD) + Text 12 Byte (gerade, 6 WORD), also `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), insgesamt 9 WORD `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Das TAG ist `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Das Object besteht aus der Sprache `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + Text 6 Byte (gerade, 3 WORD), also insgesamt 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. Das TAG ist `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [ALIAS](/de/grammar/edge/alias/), [DESCRIPTION](/de/grammar/edge/description/), [BIND](/de/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/)
- [LOCAL](/de/grammar/reference/local/), [REFERENCE-NODE](/de/grammar/edge/reference-node/)
