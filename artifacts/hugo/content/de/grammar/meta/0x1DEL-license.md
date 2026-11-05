---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Hält die Lizenz dieses Dokuments und der Werke innerhalb einer Bytefolge fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `LICENSE` (Spezifikationsdokument BIND `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DE0/` (DECLARE-Ziel `1DE0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 30 |
| Kind | Meta · Klasse: Richtlinie |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Lizenz. Reference |
| Hugo-Seite | `meta/policy/license.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Hält die Lizenz dieses Dokuments und der Werke innerhalb einer Bytefolge fest.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length-Erweiterungs-TAG]
Payload           Reference auf eine Lizenz, oder UTF8-TEXT mit SPDX-Kennung, oder URI-Value
```

- Codec: Meta `0x1DEL`, Richtlinienklasse
- Payload: eingebettete Reference oder Value ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Auf geul.org veröffentlichte Dokumente stehen unter CC0. Bei privaten Veröffentlichungen bestimmt der Issuer die Lizenz ([Issuer](../issuer.md)).
- Die ursprüngliche Lizenz des Quellwerks wird festgehalten.

## Offene Probleme {#열린-문제}

- Ob die SPDX-Kennung als Text oder als Reference auf eine GEUL-Entität abgelegt wird.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DE0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
