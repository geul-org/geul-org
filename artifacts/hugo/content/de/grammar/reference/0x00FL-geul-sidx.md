---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX ist ein deklarierendes Reference, das ein Objekt mit einem GEUL SIDX (Semantic-aligned Index) bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `GEUL-SIDX` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x00FL~0x013L` |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 15~19 |
| Kind | Reference · Klasse: Deklaration |
| Hugo-Seite | `reference/geul-sidx.md` |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

GEUL-SIDX ist ein deklarierendes Reference, das ein Objekt mit einem GEUL SIDX (Semantic-aligned Index) bezeichnet. Ein SIDX ist eine Kennung, deren Bits selbst Bedeutung (Art, Eigenschaft) tragen.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length-Erweiterungs-TAG]
SIDX              der gesamte Rest
```

- Der Quantifier ist derselbe wie bei den anderen deklarierenden Codecs. Bei Variable ist es eine anonyme Variable dieser Art ([Reference](_index.md) Variable). Die Quantifizierung erfolgt nur über die 5Q-Codes (`0x00FL~0x013L`, `C % 5`). In den SIDX-Wert wird keine Quantifizierung eingebracht.
- Das Spezifikationsdokument deklariert den SIDX als ein Rohwert-Feld der restlichen Breite. Sobald die Breitenregel feststeht, wird das geändert.

## Beispiel {#예시}

| SIDX | WORD sequence |
|---|---|
| (nicht normativ) 64 Bit `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Vergabeprinzip {#배정-방침}

- Die Rolle unterscheidet sich von [GEUL](0x00AL-geul.md). GEUL ist eine Identitäts-ID, die im Wesentlichen der Reihe nach vergeben wird (auto increment); GEUL-SIDX ist eine semantische Adresse, die bedeutungsnahen Objekten nahe Werte gibt.
- Die Nähe wird durch gesammelte Nutzungsdaten statistisch bestimmt. Bevor die Statistik vorliegt, verwendet man GEUL ID; nach der Vergabe eines SIDX verbindet man GEUL und GEUL-SIDX desselben Objekts mit [SAME-NODE](../edge/0x0A1L-same-node.md).

## Offene Probleme {#열린-문제}

- **Breite.** Sie wird anhand der Statistik festgelegt. Erwogen werden 4 WORD (64 Bit) und 16 WORD u. a. Beim SIDX liegt die Bedeutung in den oberen Bits, daher lässt sich die Regel der „kürzesten Breite“ (kein führendes `0x0000`) der anderen deklarierenden Codecs nicht unverändert übernehmen. Es wird deshalb eine feste Breite (oder eine feste Breite je Unterformat) werden. Bis dahin deklariert das Spezifikationsdokument den SIDX als Rohwert der restlichen Breite.
- **Stabilität der Vergabe.** Bei Reference bezeichnen gleiche ganzzahlige Werte dasselbe Objekt, und vergebene ID werden nicht wiederverwendet. Damit bereits vergebene SIDX auch bei geänderter Statistik nicht verschoben werden, braucht es eine Append-only-Vergabe (spärliche Vergabe, die Plätze für bedeutungsnahe Werte freilässt). Müssen vergebene SIDX häufig verschoben werden, ist zu entscheiden, ob der SIDX nicht als dauerhafte Kennung, sondern als an eine Registerversion gebundener Index definiert wird.
- **Eindeutigkeit.** Kann ein SIDX, der aus Bitbedeutungen erzeugt wird, kollidieren, passt das nicht zur Annahme „gleicher ganzzahliger Wert heißt gleiches Objekt“. Bei der Vergabe werden Kollisionen aufgelöst, damit Eindeutigkeit gewährleistet ist.
- Codebuch und Veröffentlichungsformat des Registers.

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000000F0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

Oben steht das Codec-Dokument von `GEUL-SIDX-IDENTIFIED` (`0x00FL`). Die Codec-Dokumente der anderen Mitglieder (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
