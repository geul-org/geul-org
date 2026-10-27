---
title: "SOURCE und Gliederung"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Die GEUL-ISSUER-Formate 0xC000~0xC005, mit denen verfasster Originaltext (SOURCE), Zeichenketten (TEXT), Gliederung in Abschnitte und Fälle (SECTION, CASE-BEGIN, CASE-END) und beschreibende Absätze (PROSE) eines TOULMIN-Dokuments geschrieben werden."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records, mit denen Originaltext und Gliederung eines TOULMIN-Dokuments geschrieben werden. Alle sind Edges mit `ISSUER-1WORD` (`0x7C`) und einer Formatnummer unter dem Issuer `0x0000` (GEUL) ([TOULMIN](/de/grammar/edge/toulmin/#issuer-formate)).

## Formate

| Formatnummer | Name | Layout |
|---|---|---|
| `0xC000` | SOURCE | ID, SPAN-Breite WORD, UTF8-Value |
| `0xC001` | TEXT | ID, UTF8-Value |
| `0xC002` | SECTION | ID, Abschnittscode 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (Fall) |
| `0xC004` | CASE-END | ID, REF (Fall) |
| `0xC005` | PROSE | ID, SPAN |

- ID ist die Edge Id, REF die Edge Id eines Records dieses Dokuments ([TOULMIN](/de/grammar/edge/toulmin/#gemeinsame-felder), gemeinsame Felder).
- Ein UTF8-Value ist ein [UTF8-TEXT](/de/grammar/value/text/utf8-text/)-Value-Record. Er nimmt die Bytes unverändert auf.

## SOURCE

Der gesamte verfasste Originaltext. Alle SPAN sind Bytebereiche in diesem Originaltext.

```
ID
SPAN-Breite WORD   obere 2 Bit = Breite (00=1, 01=2, 10=4, 11=8 WORD), übrige 14 Bit = 0
Originaltext       UTF8-TEXT-Value-Record
```

- SOURCE ist der erste Record des BODY. Es gibt eines je Dokument.
- Ein SPAN hat zwei Felder: Startbyte und Bytezahl. Jedes Feld ist eine vorzeichenlose Ganzzahl der Breite (1/2/4/8 WORD), die das SPAN-Breite-WORD festlegt.

## TEXT

Ein Name oder eine Zeichenkette. Die Listen F_WITH und F_GROUNDS des NODE sowie LABEL und IMPORTED-FROM des LINK verweisen per REF darauf.

## SECTION

Der Beginn eines Abschnitts. Der Abschnittscode ist 1 WORD.

| Code | Abschnitt | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | Regeln mit Bedingungsausdruck |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` wird nicht verwendet. Die Abschnitte werden in der Reihenfolge dieser Codes deklariert.
- Der Abschnittstitel ist das PROSE unmittelbar nach SECTION.

## CASE-BEGIN, CASE-END

- Der Bereich eines Falls liegt zwischen CASE-BEGIN und CASE-END, die auf denselben Fall (CASE-DECLARE-NODE) verweisen.

## PROSE

Ein beschreibender Absatz, der keine Regel ist. Er verweist nur auf einen Bereich (SPAN) des Originaltexts.

## Verwandte Seiten

- [TOULMIN](/de/grammar/edge/toulmin/), [NODE](/de/grammar/edge/toulmin/node/), [LINK](/de/grammar/edge/toulmin/link/)
