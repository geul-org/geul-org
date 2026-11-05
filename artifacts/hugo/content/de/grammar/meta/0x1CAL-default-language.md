---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert die Standardsprache der Dokumenttexte."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DEFAULT-LANGUAGE` (Spezifikationsdokument BIND `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001CA0/` (DECLARE-Ziel `1CA0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 10 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Standardsprache |
| Hugo-Seite | `meta/declaration/default-language.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | Record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Deklariert die Standardsprache der Dokumenttexte. Ein Text, bei dem keine Sprache gesondert angegeben ist, hat diese Sprache.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length-Erweiterungs-TAG]
Payload           ein Sprach-Value
```

- Codec: Meta `0x1CAL`, Definitionsklasse
- Payload: eingebetteter Value ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) oder [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- TANGEUL-Dokumente geben die Locale der Abfassung an (z. B. `en`, `ko`).

## Beispiel {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001CA0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
