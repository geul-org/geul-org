---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält die LOCAL ID fest, die die nächste Version des Dokuments einer neuen Aussage zuweist (auto increment eines DBMS, MySQL AUTO_INCREMENT)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `NEXT-LOCAL-ID` (Spezifikationsdokument BIND `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DD0/` (DECLARE-Ziel `1DD0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 29 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Als Nächstes zu vergebende LOCAL ID (auto increment). Steht im HEAD der Versionsliste `versions.geul` |
| Hugo-Seite | `meta/lineage/next-local-id.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | Rest-Rohwert (`0xFFFF`) |  |  |

Hält die LOCAL ID fest, die die nächste Version des Dokuments einer neuen Aussage zuweist (auto increment eines DBMS, MySQL `AUTO_INCREMENT`). Jede in irgendeiner Version des Dokuments vergebene LOCAL ID ist kleiner als dieser Wert.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           als Nächstes zu vergebende LOCAL ID, unsigned Ganzzahl in der schmalsten Breite
```

- Codec: Meta `0x1DDL`, Abstammungsklasse
- Payload: Rohwert (unsigned Ganzzahl in der schmalsten Breite)
- Anzahl: höchstens eines
- Ablageort: HEAD des Versionslisten-Dokuments `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interpretation und Gültigkeit {#해석과-유효성}

- Die LOCAL ID (einschließlich Edge Id) ist eine versionsübergreifende Identität ([Revision](../document.md#개정)). Eine neue Aussage erhält diesen Wert, und der Wert steigt um 1. Eine gelöschte LOCAL ID wird nicht wiederverwendet. Deshalb sinkt dieser Wert auch dann nicht, wenn die Aussage mit dem Höchstwert gelöscht wird.
- Die LOCAL ID `0` wird nicht vergeben, daher ist der Anfangswert `1`. Gibt es noch keine Version, steht dieses Meta nicht, und die nächste Nummer ist `1`.
- Die veröffentlichende Stelle aktualisiert und schreibt ihn in das neue Listendokument, wenn sie eine Version veröffentlicht. Er muss größer sein als jede in der veröffentlichten Version verwendete LOCAL ID. Ist er kleiner oder gleich, ist es invalid.
- Der Wert wächst nur. Ist er kleiner als der Wert des unmittelbar vorangehenden Listendokuments ([PARENT](0x1D1L-parent.md)), ist es invalid.
- Bei Dokumenten ohne Versionsverwaltung (Dokumente ohne `versions.geul`, namenlose Dokumente) gibt es ihn nicht. Solche Dokumente haben auch keinen Diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- Im Dokumentkörper (Versionsdokument) steht er nicht. Die Nummer zu merken ist nicht Dokumentinhalt, sondern Zustand der veröffentlichenden Stelle, die das Dokument fortschreibt (bei git nicht der Commit, sondern die Seite der refs).

## Beispiel {#예시}

Nächste zu vergebende Nummer 524:

```
1DD1 020C
```

- TAG `1DD1`(Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DD0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
