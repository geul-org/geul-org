---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Hält Umfang und Grundlage der Einwilligung fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `CONSENT` (Spezifikationsdokument BIND `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E20/` (DECLARE-Ziel `1E20`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 2 |
| Kind | Meta · Klasse: Richtlinie |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Einwilligungsumfang und -grundlage |
| Hugo-Seite | `meta/policy/consent.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Hält Umfang und Grundlage der Einwilligung fest.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[Length-Erweiterungs-TAG]
Payload           Reference auf die Einwilligungsgrundlage oder Text
```

- Codec: Meta `0x1E2L`, Richtlinienklasse
- Payload: eingebettete Reference oder Value
- Anzahl: mehrere möglich

## Offene Probleme {#열린-문제}

- Struktur der Umfangsangabe (Zweck, Dauer, Weitergabe an Dritte).

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E20/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
