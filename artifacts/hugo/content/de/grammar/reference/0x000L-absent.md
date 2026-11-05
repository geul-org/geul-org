---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT ist ein Slot-Marker für „nicht angegeben“."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT ist ein [Slot-Marker](../slot-marker.md) für „nicht angegeben“. Er sagt etwas über das Dokument aus, nämlich dass dieser Slot nicht gefüllt wurde, und behauptet nichts über die Welt.

| Eintrag | Wert |
|---|---|
| Name | `ABSENT` (Spezifikationsdokument BIND `ABSENT`) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000000/` (DECLARE-Ziel `0000`) |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 0 |
| Kind | Reference · Klasse: Slot-Marker |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Nicht angegeben. Ein optionales Feld wurde ausgelassen. Behauptet nichts über die Welt |
| Hugo-Seite | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Es gibt keinen Payload. Es gibt weder eine Ziel-ID noch einen Quantifier ([Slot-Marker](../slot-marker.md#레이아웃)).
- Bei `0x000L` ist die Form mit Payload (L ≥ 1) Reserved.
- Textnotation in `geul show` und `geul add`: `ABSENT`.

## Bedeutung {#뜻}

| Eintrag | Nicht angegeben |
|---|---|
| Worüber es etwas aussagt | **Dokument**: Dieser Slot wurde nicht gefüllt |
| Logik | Behauptet nichts |
| Weltannahme | Offene Welt (keine Information) |
| Wikidata | Der betreffende Snak existiert nicht |

## Akzeptanz {#수용}

- Akzeptiert wird er nur von Feldern mit CODEC-Ziel `0000`. Ein solches Feld ist ein **optionales Feld**. Wird ein optionales Feld ausgelassen, steht an seiner Stelle ein einzelnes WORD `0x0000`. Auch ein optionales Feld belegt seinen Slot immer ([Codec-Spezifikationsdokument](../codec-spec.md#선택-필드와-자리-표지)). Beispiele: Origin von [SOURCE](../edge/0x0C0L-source.md); Einheit, Unter- und Obergrenze von [QUANTITY](../value/0x066L-quantity.md).
- Nicht verwendbar ist er bei Wildcards, bei Feldern ohne CODEC, an Record-Slots von HEAD und BODY, an Edge-Id-Slots und in Rohwert-Feldern (gemeinsame Regel der [Slot-Marker](../slot-marker.md#수용-규칙)).

## Pflichten der Leseseite {#읽는-쪽의-의무}

- **ABSENT sagt nichts über die Welt aus.** Er wird nicht als UNKNOWN-VALUE oder NO-VALUE gelesen.
- Ein Wert, den ein Konverter nicht übertragen konnte (die Quelle hat ihn), darf nicht als UNKNOWN-VALUE geschrieben werden, denn in der Quelle ist der Wert bekannt. Auch einen Slot, zu dem die Quelle schweigt (z. B. den Origin eines [SOURCE](../edge/0x0C0L-source.md), dessen Quelle nicht beschrieben ist), schreibt der Konverter als ABSENT.
- Im Beurteilungsgraphen sind bei ABSENT und bei fehlender Aussage alle Vergleichsoperatoren unbestimmt (U). Soll ABSENT als empty gelesen werden, muss die Eingabeseite eine geschlossene Welt deklarieren ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Beispiel {#예시}

`0x0000`, 1 WORD. Beispiel: der Einheiten-Slot eines QUANTITY ohne angegebene Einheit.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält nur ein DECLARE (Ziel `0000`). Ohne Payload gibt es kein FIELD. Der Decoder bringt Bedeutung und Akzeptanzregeln des Markers mit ([Schicht 0](../publishing.md#층)). Zum Lesen des Markers wird kein Codec-Dokument abgefragt.

## Verwandte Seiten {#관련-페이지}

- [Slot-Marker](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec-Spezifikationsdokument](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000000/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
