---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält den unveränderlichen Namen fest, der an eine Version gehängt wird (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `TAG` (Spezifikationsdokument BIND `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DA0/` (DECLARE-Ziel `1DA0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 26 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Unveränderlicher Name, der an eine Version gehängt wird. TEXT-Value und Inhaltshash (git annotated tag) |
| Hugo-Seite | `meta/lineage/tag.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | Record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | Record | `07C0` SHA-256-DIGEST, `0000` ABSENT (optionales Feld) |  |

Hält den unveränderlichen Namen fest, der an eine Version gehängt wird (git annotated tag).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length-Erweiterungs-TAG]
Name              UTF8-TEXT-*-Value
Ziel              SHA-256-DIGEST-Value oder Auslassungsmarker 0x0000 (optionales Feld). Bei Auslassung diese Version
```

- Codec: Meta `0x1DAL`, Abstammungsklasse
- Payload: eingebetteter Value (Text + optionaler Inhaltshash)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Name ist ein [UTF8-TEXT](../value/0x072L-utf8-text.md), das Ziel ein [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- Wird das Ziel ausgelassen (ABSENT `0x0000`, [CODEC](../edge/0x0BEL-codec.md) optionales Feld), ist es ein Name, der an dieses Dokument selbst gehängt wird. Den eigenen Inhaltshash kann man nicht in sich selbst schreiben. Die Spezifikation `0x1DA0` von geul.org besteht aus zwei Record-Feldern: name (`0720`·`0730`) und target (`07C0`·`0000`).
- Derselbe Name wird nicht für eine andere Version wiederverwendet.

## Beispiel {#예시}

- Name `v1`, diese Version: `1DA3 0721 7631 0000`

## Offene Probleme {#열린-문제}

- Ob TAG nötig ist, obwohl es eine Versions-ID (laufende Nummer) gibt.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DA0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
