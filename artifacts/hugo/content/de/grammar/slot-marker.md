---
title: "Slot-Marker"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Ein Slot-Marker ist ein 1-WORD-Record, der die Stelle eines Record-Felds füllt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Slot-Marker ist ein 1-WORD-Record, der die Stelle eines Record-Felds füllt. Er verweist auf nichts. Es sind die Codes, die den ersten drei Plätzen `0x000L~0x002L` in Reference-Abschnitt 0 zugewiesen sind. Jeder Marker hat eine Seite: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

An einer Wertstelle können drei Aussagen stehen. Der Wert wurde nicht angegeben, es gibt einen Wert, aber er ist unbekannt, oder es gibt keinen Wert. Die drei sind verschieden. Der Slot-Marker schreibt diese drei als drei benachbarte WORD.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, Abschnitt 0 (Reference), Codec 0~2, LLLL 0000 (1 WORD)
```

| WORD | Name | Bedeutung | Schreibweise |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | nicht angegeben | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | unbekannt: Es gibt einen Wert. Welcher, ist unbekannt | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | kein Wert: Es gibt keinen Wert | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | Diese TAG-Form (Marker mit Payload) ist nicht zugewiesen | |

- Marker haben **keinen Quantifier.** Die Quantifizierung wird nur aus den 5Q-Systemen gelesen (`5 <= C < 30` in Abschnitt 0, `C < 30` in Abschnitt 1). `0x0010` UNKNOWN-VALUE wird nicht mit `C % 5` als Generic interpretiert ([Reference](reference/_index.md) Quantifier).
- Es gibt keinen Payload. Auch keine Objekt-ID.
- Auch ein Decoder ohne Codebook erkennt allein am TAG WORD das Kind Reference und 1 WORD und überspringt ihn. „Ist der WORD-Wert `0x0000`, `0x0010` oder `0x0020`, ist es ein Slot-Marker“ erkennt man mit `w & 0xF == 0 && w <= 0x0020`.
- Die Schreibweisen `ABSENT`, `UNKNOWN` und `NONE` sind die Textschreibweisen von `geul show` und `geul add`.

## Drei Unterscheidungen {#세-가지-구분}

| | nicht angegeben (ABSENT) | unbekannt (UNKNOWN-VALUE) | kein Wert (NO-VALUE) |
|---|---|---|---|
| Worüber es etwas sagt | **Dokument**: Diese Stelle wurde nicht gefüllt | **Welt**: Es gibt einen Wert. Welcher, ist unbekannt | **Welt**: Es gibt keinen Wert |
| Logik | behauptet nichts | `∃x. P(s, x)`, x ist nicht identifiziert | `¬∃x. P(s, x)` |
| Weltannahme | offene Welt (keine Information) | Existenz geschlossen, Identität offen | geschlossene Welt für (s, P, einschränkende Bedingung) |
| Wikidata | der betreffende snak fehlt | `somevalue` | `novalue` |
| Verwendung | optionales Feld mit CODEC-Ziel `0000` (SOURCE Origin usw.) | Feld mit CODEC-Ziel `0010` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Feld mit CODEC-Ziel `0020` (TRIPLE Object, QUALIFIER Value) |
| „Wie viele Kinder (P40)?“ | unbekannt | mindestens 1 | 0 |
| „Gibt es einen Endzeitpunkt (P582)?“ | unbekannt → unbekannt, ob es noch gilt | beendet. Zeitpunkt unbekannt | nicht beendet (Behauptung) |

Dieselbe Unterscheidung gilt auch auf Ebene der Proposition. **Ein im Dokument fehlendes TRIPLE** ist „nicht angegeben“. Ein GEUL-Dokument ist eine offene Welt, und aus dem Fehlen einer Aussage folgt nicht, dass der Sachverhalt nicht besteht. „Es gibt keinen“ kann man nur sagen, wenn man es **ausdrücklich** als NO-VALUE schreibt.

## Annahmeregel {#수용-규칙}

- Ein Slot-Marker ist nur gültig, wenn die [CODEC](edge/0x0BEL-codec.md)-Liste des Felds **dasselbe WORD als exaktes Ziel führt.** Das Ziel `0000` bedeutet „optionales Feld“, `0010` „nimmt unbekannt an“, `0020` „nimmt kein Wert an“.
- Wildcards (`000F`, `060F` usw., `L=1111`) nehmen keine Marker an. Auch beliebige Reference (`000F`·`020F`·`040F`) überschneiden sich nicht mit Markern.
- Auch ein Record-Feld ohne CODEC („beliebiger Record“) nimmt keine Marker an.
- Ein Marker an den Record-Stellen von HEAD und BODY sowie an der Edge-Id-Stelle ist invalid.
- In Rohwert-Feldern kann kein Marker stehen. Ein Rohwert hat kein TAG und daher keine Stelle für einen 1-WORD-Marker.
- Eine CODEC-Liste, die nur Marker-Ziele enthält (immer ein Marker), ist invalid.
- Die Bedeutung des Markers (was es gibt und was nicht) legt die Edge-Spezifikation fest, die ihn annimmt. Das entspricht dem Grundsatz, dass Quantifizierung und Verneinung nicht Reference, sondern Edge festlegt.
- Bedeutung und Annahmeregel des Markers gehören zur [Schicht 0](publishing.md#층) (im Decoder eingebaut). Alle drei haben keinen Payload und verursachen daher keine Einbaukosten. Dennoch gibt es für jeden Code ein Codec-Dokument. Das Codec-Dokument enthält nur DECLARE und kein FIELD.

## Pflichten der lesenden Seite {#읽는-쪽의-의무}

Sie stehen jeweils auf der Seite des Markers. Die Kernpunkte sind:

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) ist keine Wertangabe, sondern die Behauptung einer Existenz. Es ist weder gleich noch ungleich irgendeinem Wert, und dieses TRIPLE wird nicht als Duplikat zusammengeführt.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) ist innerhalb der einschränkenden Bedingung dieser Proposition geschlossen.
- Bei beiden Markern gilt rank unverändert, und wenn sie als QUALIFIER-Wert verwendet werden, ändern sie die Bedeutung dieser Einschränkung.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) sagt nichts über die Welt aus. Ein nicht übertragener Wert wird nicht als UNKNOWN-VALUE geschrieben.

## Unterschied zu anderen „Nichts“ {#다른-없음과의-차이}

- Die Codec-Regel, die [LOCAL](reference/0x005L-local.md) `0` als „nichts“ verwendet ([TOULMIN](toulmin/_index.md) REF usw.), ist eine Vereinbarung innerhalb dieses Codecs. Sie unterscheidet sich vom Slot-Marker.
- Identified LOCAL wird nicht als null oder Sentinel verwendet. Um Unbekanntes oder Fehlendes zu schreiben, setzt man in einem Feld, das Marker annimmt, einen Marker.

## Beispiel {#예시}

Die Grenze zwischen Q30 (Vereinigte Staaten) und Q34266 (Russisches Kaiserreich), Endzeitpunkt unbekannt. Die Edge Ids dienen der Erläuterung.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Die Zentralbank von Q30 gab es von 1811 bis 1816 nicht.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- Die Marker-Stelle ist 1 WORD. TRIPLE hat dann 9 WORD (`0AA8`), QUALIFIER 8 WORD (`0AB7`).
- In einfacher Form ist „keine Kinder (P40)“ `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Verwandte Seiten {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [Codec-Spezifikationsdokument](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
