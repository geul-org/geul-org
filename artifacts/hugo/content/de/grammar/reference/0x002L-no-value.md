---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE ist ein Slot-Marker für „keiner“."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE ist ein [Slot-Marker](../slot-marker.md) für „keiner“. Er ist eine Behauptung über die Welt: Es gibt keinen Wert.

| Eintrag | Wert |
|---|---|
| Name | `NO-VALUE` (Spezifikationsdokument BIND `NO-VALUE`) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000020/` (DECLARE-Ziel `0020`) |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 2 |
| Kind | Reference · Klasse: Slot-Marker |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Keiner. Es gibt keinen Wert (Wikidata `novalue`) |
| Hugo-Seite | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Es gibt keinen Payload. Es gibt weder eine Ziel-ID noch einen Quantifier ([Slot-Marker](../slot-marker.md#레이아웃)).
- Bei `0x002L` ist die Form mit Payload (L ≥ 1) Reserved.
- Textnotation in `geul show` und `geul add`: `NONE`.

## Bedeutung {#뜻}

| Eintrag | Keiner |
|---|---|
| Worüber es etwas aussagt | **Welt**: Es gibt keinen Wert |
| Logik | `¬∃x. P(s, x)` |
| Weltannahme | Geschlossene Welt bezüglich (s, P, Einschränkungsbedingung) |
| Wikidata | `novalue` |

## Akzeptanz {#수용}

- Akzeptiert wird er nur von Feldern mit CODEC-Ziel `0020`. Ein solches Feld nimmt die Behauptung „keiner“ an. Beispiele: Object von [TRIPLE](../edge/0x0AAL-triple.md), Value von [QUALIFIER](../edge/0x0ABL-qualifier.md).
- Nicht verwendbar ist er bei Wildcards, bei Feldern ohne CODEC, an Record-Slots von HEAD und BODY, an Edge-Id-Slots und in Rohwert-Feldern (gemeinsame Regel der [Slot-Marker](../slot-marker.md#수용-규칙)).

## Pflichten der Leseseite {#읽는-쪽의-의무}

- **NO-VALUE ist innerhalb der Einschränkungsbedingungen der Aussage geschlossen.** Hängt ein QUALIFIER daran, gilt die Schließung nur in diesem Bereich. Q30 P1304 NO-VALUE (P580 1811, P582 1816) bedeutet, dass es nur von 1811 bis 1816 keine Zentralbank gab, und widerspricht dem Wert-TRIPLE derselben Eigenschaft (Federal Reserve, preferred) nicht.
- Stehen bei gleichem Subject und Predicate ein NO-VALUE und ein Wert-TRIPLE mit gleichem rank nebeneinander, ohne dass sich die Einschränkungsbedingungen unterscheiden, ist das ein Widerspruch. Der Prüfer gibt eine Warnung aus. Er lehnt nicht ab. Dieser Zustand kommt auch in Wikidata vor, und die Leseseite wählt per rank.
- **Der rank gilt unverändert.** Bei der Wahl des repräsentativen Werts (truthy) kommt auch ein TRIPLE mit NO-VALUE als Kandidat in Frage.
- **Als QUALIFIER-Wert ändert er die Bedeutung der Einschränkung.** `P582 = NONE` behauptet, dass es nicht beendet ist. Fehlt der P582-QUALIFIER ganz, weiß man nicht, ob es beendet ist.
- „Es gibt keinen“ lässt sich nur sagen, wenn man es **als NO-VALUE hinschreibt**. Fehlt ein TRIPLE im Dokument, ist das „nicht angegeben“ (offene Welt).

## Beispiel {#예시}

`0x0020`, 1 WORD. Beispiel: „kein Kind“ (P40) ist `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, der Object-Slot ist `0020`).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält nur ein DECLARE (Ziel `0020`). Ohne Payload gibt es kein FIELD. Der Decoder bringt Bedeutung und Akzeptanzregeln des Markers mit ([Schicht 0](../publishing.md#층)). Zum Lesen des Markers wird kein Codec-Dokument abgefragt.

## Verwandte Seiten {#관련-페이지}

- [Slot-Marker](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec-Spezifikationsdokument](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000020/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
