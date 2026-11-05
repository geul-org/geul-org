---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL ist ein deklarierendes Reference, das ein Objekt mit einer vom Dokument vergebenen ID bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `LOCAL` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x005L~0x009L` |
| Abschnitt | 0 `0000` (Reference-Entität), Offset im Abschnitt C = 5~9 |
| Kind | Reference · Klasse: Deklaration |
| Hugo-Seite | `reference/local.md` |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

LOCAL ist ein deklarierendes Reference, das ein Objekt mit einer vom Dokument vergebenen ID bezeichnet. Es verweist ohne externen Issuer auf Objekte innerhalb des Dokuments. Um von außerhalb des Dokuments darauf zu verweisen, legt man im Dokument das Meta [DOC-ID](../meta/0x1C7L-doc-id.md) an, und ein anderes Dokument verweist mit einem zeigenden Reference darauf.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length-Erweiterungs-TAG]
LOCAL ID          vorzeichenloses Big-Endian in der kürzesten Breite
```

| LOCAL ID | Gesamt | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Die Codecs sind `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal) und `0x009L` (Variable). Das TAG WORD von Identified ist `0000 0000 0101 LLLL`.
- Es gilt die gemeinsame Reference-Regel, die Ziel-ID mit der kleinstmöglichen WORD-Anzahl zu schreiben.

## Edge Id {#edge-id}

- Das LOCAL als erstes Element des Edge-Payloads ist die Edge-Id-Deklaration dieses Edge ([Edge](../edge/_index.md)). Für die Deklaration einer Edge Id wird nur Identified (`0x005L`) verwendet.
- Ein LOCAL an anderer Stelle im Edge-Payload ist eine Erwähnung. Ein Objekt dieses Dokuments wird bei jeder Erwähnung als LOCAL geschrieben. Einen eigenen zeigenden Code für Objekte dieses Dokuments gibt es nicht.

## Vergabe von Kennungen {#식별자-할당}

- Die ID ist eine ganze Zahl und wird vom Encoder vergeben. Größe und Vergabereihenfolge der Zahl haben außer der Identität keine Bedeutung.
- **UNIQUE (Pflicht).** In einem Dokument bezeichnet eine LOCAL ID genau ein Objekt. Eine Edge Id wird pro Dokument nur einmal deklariert (HEAD-Edge und BODY-Edge teilen sich einen Nummernraum). Deklarieren zwei oder mehr Edge dieselbe Edge Id, ist das invalid.
- **AUTO INCREMENT (Empfehlung).** Eine neue ID wird als bisher in diesem Dokument vergebener Höchstwert + 1 vergeben und wächst in Dokumentreihenfolge. Das gilt auch über Versionen hinweg (neu angelegt wird mit einem Wert größer als gelöschte IDs). Es ist nur eine Empfehlung und keine Gültigkeitsbedingung; auch ein Dokument ohne Zuwachs ist valid. Der Decoder verlässt sich weder auf die Größe noch auf die Lückenlosigkeit der IDs.
- Die ID `0` wird nicht vergeben. Sie bezeichnet kein Objekt und wird auch nicht als Edge Id verwendet. Ziel-IDs werden ab `1` vergeben.
- Auf ein Dokument verweist man, innerhalb wie außerhalb dieses Dokuments, nur mit einem einzigen [DOC-POINTER](0x041L-doc-pointer.md) (auf sich selbst mit dem DOC-POINTER auf die eigene `DOC-ID`). Auch an ein Dokument lassen sich `BIND`, `LABEL` und Beurteilungs-Edge anhängen.
- Auf den Issuer selbst verweist man mit [ISSUER-POINTER](0x040L-issuer-pointer.md). Die Dokument-ID `0` ist das Indexdokument für die Begriffsdefinitionen des Issuers.
- Bei Codecs, die der `0` an einer Komponentenstelle eine Bedeutung geben ([TOULMIN](../toulmin/_index.md) „keiner“ bei REF und Ausführungs-Edge, „ganzes Dokument“ beim Target des HEAD-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)), gilt die Regel dieses Codecs. Das ist eine Vereinbarung innerhalb dieses Codecs und etwas anderes als die [Slot-Marker](../slot-marker.md).
- Eine einmal vergebene ID wird im selben Dokument nicht wiederverwendet.
- Es wird immer die kleinste Breite verwendet, die den Wert darstellen kann.

## Identität und Geltungsbereich {#동일성과-범위}

- Im selben Dokument bezeichnen LOCAL ID mit gleichem ganzzahligem Wert dasselbe Objekt. Die Kodierungsbreite gehört nicht zur Identität.
- Ein Identified LOCAL steht für ein identifiziertes Objekt. Es wird nicht als anonym, unbestimmt, null oder Sentinel verwendet. Dass ein Wert existiert, aber unbekannt ist (UNKNOWN-VALUE), oder dass es keinen Wert gibt (NO-VALUE), schreibt man in dem Feld, das diese Marker akzeptiert, als [Slot-Marker](../slot-marker.md).
- Verschiedene LOCAL ID sind nur verschiedene Reference. Es heißt nicht, dass auch die Objekte der Wirklichkeit verschieden sind.
- Die Identität von LOCAL wird nicht über das Dokument hinaus ausgedehnt. Dieselbe Zahl in einem anderen Dokument ist unabhängig.
- Ein Variable-LOCAL (`0x009L`) ist eine benannte Diskursvariable ([Reference](_index.md) Variable).

## Zusammenführung {#병합}

Beim Zusammenführen mehrerer Dokumente zu einem erstellt man für jedes Quelldokument eine Zuordnungstabelle `old ID → new ID`, vergibt alle LOCAL ID neu als IDs des neuen Dokuments und ersetzt alle Verweise.

- IDs, die im selben Quelldokument gleich waren, müssen auch nach der Zusammenführung gleich sein.
- Dieselbe Zahl aus verschiedenen Quelldokumenten ist unabhängig und wird nicht automatisch zum selben Reference vereinigt.
- Bleibt auch nur ein LOCAL unersetzt, wird die Zusammenführung abgelehnt.

## Gültigkeit {#유효성}

Die folgenden Kodierungen oder Vergaben sind invalid.

- Non-minimale Kodierung mit führendem WORD `0x0000` (Ausnahme: `0x0000`, 1 WORD, für den Wert 0)
- Der Codec an der Stelle der Edge-Id-Deklaration ist nicht Identified (`0x005L`) oder die ID ist `0`
- Dieselbe ID wird im selben Dokument überlappend an verschiedene Objekte vergeben
- Dieselbe Edge Id wird im selben Dokument zwei- oder mehrmals deklariert

## Beispiel {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000050/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

Oben steht das Codec-Dokument von `LOCAL-IDENTIFIED` (`0x005L`). Die Codec-Dokumente der anderen Mitglieder (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
