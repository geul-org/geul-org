---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert das auf das Dokument angewandte Profil."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `PROFILE` (Spezifikationsdokument BIND `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C60/` (DECLARE-Ziel `1C60`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 6 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Angewandtes Profil |
| Hugo-Seite | `meta/declaration/profile.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | Record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

Deklariert das auf das Dokument angewandte Profil. Dieselben Records werden als die vom Profil bestimmten Codec-Dokumente interpretiert (z. B. bei `tangeul-1.0` als [TOULMIN](../toulmin/_index.md)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length-Erweiterungs-TAG]
Payload           UTF8-TEXT-Value "<Name>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, Definitionsklasse
- Payload: eingebetteter Value ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Ein Profil mit anderer major wird abgelehnt. Unterschiede in minor sind erlaubt (nur additive Änderungen).
- Gibt es kein Profil, wird allein mit der GEUL-Grundgrammatik und den Spezifikationen der direkten Codes gelesen.

## Beispiel {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Offene Probleme {#열린-문제}

- Profilnamen-Registry (geul.org) und Namensregeln.
- Ob das Profil über eine Dokument-ID referenziert (IMPORT) oder als Text abgelegt wird.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C60/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
