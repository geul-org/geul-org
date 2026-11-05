---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE ist ein Slot-Marker für „unbekannt“."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE ist ein [Slot-Marker](../slot-marker.md) für „unbekannt“. Er ist eine Behauptung über die Welt: Ein Wert existiert, aber man weiß nicht, welcher.

| Eintrag | Wert |
|---|---|
| Name | `UNKNOWN-VALUE` (Spezifikationsdokument BIND `UNKNOWN-VALUE`) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000010/` (DECLARE-Ziel `0010`) |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 1 |
| Kind | Reference · Klasse: Slot-Marker |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Unbekannt. Ein Wert existiert, aber man weiß nicht, welcher (Wikidata `somevalue`) |
| Hugo-Seite | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Es gibt keinen Payload. Es gibt weder eine Ziel-ID noch einen Quantifier ([Slot-Marker](../slot-marker.md#레이아웃)).
- Bei `0x001L` ist die Form mit Payload (L ≥ 1) Reserved.
- Textnotation in `geul show` und `geul add`: `UNKNOWN`.

## Bedeutung {#뜻}

| Eintrag | Unbekannt |
|---|---|
| Worüber es etwas aussagt | **Welt**: Ein Wert existiert. Welcher, ist unbekannt |
| Logik | `∃x. P(s, x)`, x ist nicht identifiziert |
| Weltannahme | Existenz geschlossen, Identität offen |
| Wikidata | `somevalue` |

## Akzeptanz {#수용}

- Akzeptiert wird er nur von Feldern mit CODEC-Ziel `0010`. Ein solches Feld nimmt die Behauptung „unbekannt“ an. Beispiele: Object von [TRIPLE](../edge/0x0AAL-triple.md), Value von [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin von [SOURCE](../edge/0x0C0L-source.md).
- Nicht verwendbar ist er bei Wildcards, bei Feldern ohne CODEC, an Record-Slots von HEAD und BODY, an Edge-Id-Slots und in Rohwert-Feldern (gemeinsame Regel der [Slot-Marker](../slot-marker.md#수용-규칙)).

## Pflichten der Leseseite {#읽는-쪽의-의무}

- **UNKNOWN-VALUE ist kein Wert, sondern eine Existenzbehauptung.** Er ist keinem anderen Wert gleich und auch nicht ungleich (Vergleichsergebnis unbestimmt). Auch zwei UNKNOWN-VALUE gelten nicht als derselbe Wert. Jedes Vorkommen ist eine eigene, unabhängige Existenzquantifizierung (wie ein Blank Node in Wikidata).
- Daher sind zwei bytegleiche TRIPLE (`P40 Q… UNKNOWN` ×2) keine Duplikate. Es können zwei Kinder sein oder eines. Ein TRIPLE mit UNKNOWN-VALUE wird nicht als Duplikat zusammengeführt.
- Wird die Identität später bekannt, erscheint eine neue Version dieses TRIPLE. Auf UNKNOWN-VALUE kann man nicht verweisen. Wird eine Ko-Referenz benötigt, verwendet man LOCAL Variable ([Reference](_index.md#quantifier) Variable).
- **Der rank gilt unverändert.** Bei der Wahl des repräsentativen Werts (truthy) kommt auch ein TRIPLE mit UNKNOWN-VALUE als Kandidat in Frage.
- **Als QUALIFIER-Wert ändert er die Bedeutung der Einschränkung.** `P582 = UNKNOWN` bedeutet: beendet, Zeitpunkt unbekannt. Die Aussage wird nicht als weiterhin gültig gelesen.
- UNKNOWN-VALUE ist die Behauptung „es gibt einen“ und wird nur geschrieben, wenn die Quelle es so sagt. Ein nicht übertragener Wert wird nicht als UNKNOWN-VALUE geschrieben.

## Beispiel {#예시}

`0x0010`, 1 WORD. Beispiel: Das Ende (P582) der Grenze Q30–Q34266 ist unbekannt: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, der Value-Slot ist `0010`).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält nur ein DECLARE (Ziel `0010`). Ohne Payload gibt es kein FIELD. Der Decoder bringt Bedeutung und Akzeptanzregeln des Markers mit ([Schicht 0](../publishing.md#층)). Zum Lesen des Markers wird kein Codec-Dokument abgefragt.

## Verwandte Seiten {#관련-페이지}

- [Slot-Marker](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec-Spezifikationsdokument](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000010/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
