---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER ist ein Aussage-Edge, der eine Bedingung anfügt, die die Proposition eines anderen Edge (hauptsächlich TRIPLE) einschränkt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `QUALIFIER` (BIND des Spezifikationsdokuments `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000AB0/` (DECLARE-Ziel `0AB0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 11 |
| Kind | Edge · Familie: Aussage, Gruppe: Proposition |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Eine Bedingung, die die Proposition eines anderen Edge einschränkt. Property, Target (Edge Id), Value (Wert oder UNKNOWN-VALUE-/NO-VALUE-Marker). Er ist Teil der Proposition |
| Hugo-Seite | `edge/qualifier.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `target` | #3 | Record | `0050` LOCAL |  |
| 3 | `value` | #4 | Record | `000F` gesamter Abschnitt 0 (Wildcard, Reference), `020F` gesamter Abschnitt 1 (Wildcard, Reference), `040F` gesamter Abschnitt 2 (Wildcard, Reference), `060F` gesamter Abschnitt 3 (Wildcard, Value), `080F` gesamter Abschnitt 4 (Wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER ist ein Aussage-Edge, der eine Bedingung anfügt, die die Proposition eines anderen Edge (hauptsächlich [TRIPLE](0x0AAL-triple.md)) einschränkt. Codec `0x0ABL`.

Er entspricht einem einzelnen Wikidata-qualifier (snak): eine Property und ein Wert.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Property          Reference-Record (WIKIDATA-PID usw.)
Target            LOCAL Reference-Record (Edge Id des eingeschränkten Edge)
Value             Reference- oder Value-Record, oder Slot-Marker 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- Die Reihenfolge der Komponenten ist dieselbe wie bei TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Der Decoder liest auf demselben Weg. Die Rollen legt der Codec fest.

## Interpretation und Gültigkeit {#해석과-유효성}

- Property und Target sind jeweils genau ein vollständiger Reference-Record, und das Target ist ein LOCAL Reference. Die Spezifikationsdokumente von geul.org setzen beim Target den [CODEC](0x0BEL-codec.md) LOCAL (`0050`). Der Value ist genau ein vollständiger Reference- oder Value-Record oder ein [Slot-Marker](../slot-marker.md) `0x0010` (UNKNOWN-VALUE)·`0x0020` (NO-VALUE) mit 1 WORD. Das Spezifikationsdokument setzt beim Value die CODEC `000F`, `020F`, `040F` (beliebiges Reference), `060F`, `080F` (beliebiger Value), `0010`, `0020`. ABSENT (`0x0000`) wird nicht akzeptiert. Property und Target akzeptieren keine Slot-Marker. Der Cursor nach dem Lesen des Value muss mit dem Ende des Edge übereinstimmen.
- Das Target ist eine Edge Id innerhalb desselben Dokuments. Ein QUALIFIER steht im selben Dokument wie der Edge, den er einschränkt.
- Ist das Target das [SOURCE](0x0C0L-source.md#문서-전체의-출처) im HEAD (Ursprung des gesamten Dokuments), steht der QUALIFIER ebenfalls im HEAD, nach diesem SOURCE. Alle anderen QUALIFIER stehen im BODY. Steht ein QUALIFIER mit dem HEAD-SOURCE als Target im BODY, ist es invalid.
- Das Target kann auch ein anderer Edge als TRIPLE sein. Ein QUALIFIER an einem [SOURCE](0x0C0L-source.md) schränkt den Zitiervorgang ein (Abrufdatum, Stelle innerhalb der Quelle usw.). Auch die Bedeutung eines SOURCE ist die Gesamtheit aller QUALIFIER, die auf ihn verweisen.
- **Ein QUALIFIER ist Teil der Proposition.** Er ist keine eigene Behauptung über die Proposition, sondern schränkt die Bedingungen ein, unter denen die Proposition wahr ist. Die Bedeutung des Ziel-TRIPLE ist die Gesamtheit aller QUALIFIER, die auf es verweisen.
  - Die Quelle einer Proposition wird als [SOURCE](0x0C0L-source.md) geschrieben. Eigenschaften des Quellknotens (Titel, Autor usw.) werden als TRIPLE mit der Quelle als Subject geschrieben.
- Zum selben Target kann es mehrere QUALIFIER derselben Property geben. Die Reihenfolge der QUALIFIER mit demselben Target ist die Reihenfolge im Dokument (eine Ausnahme, bei der die Edge-Reihenfolge Bedeutung hat).

## Unbekannt und nicht vorhanden {#알-수-없음과-없음}

Ist der Value eines QUALIFIER ein Slot-Marker, ändert sich die Bedeutung der Einschränkung. Als Beispiel dient der Endzeitpunkt (P582).

| An das Ziel-TRIPLE angefügt | Bedeutung | Ist die Proposition noch gültig |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Endete 1974 | Nein |
| `QUALIFIER P582 #n UNKNOWN` | Endete. Wann, ist unbekannt (Wikidata `somevalue`) | Nein |
| `QUALIFIER P582 #n NONE` | Es wird behauptet, dass es nicht endete (Wikidata `novalue`) | Ja |
| Kein P582-QUALIFIER | Ob es endete, ist unbekannt (offene Welt) | Unbekannt |

- Verwirft man `somevalue` und `novalue` eines Wikidata-qualifier, wird die Proposition breiter. Ein Grenz-TRIPLE, dessen Endzeitpunkt-somevalue verworfen wurde, wird als „noch gültige Grenze“ gelesen. Deshalb werden sie bei der Übertragung als Marker übertragen.
- UNKNOWN-VALUE gelten untereinander nicht als derselbe Wert. Das Vergleichsergebnis ist unbestimmt.

## Beispiel (nicht normativ) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Der Value ist [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Grenze (P47) zwischen Q30 (Vereinigte Staaten) und Q34266 (Russisches Kaiserreich), Endzeitpunkt unbekannt. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (Abschnitt 5): Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + Marker 1.

An das NO-VALUE-TRIPLE `#3161` zur Zentralbank (P1304) von Q30 wird ein Zeitraum angefügt. Es gab sie nur von 1811 bis 1816 nicht.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [Slot-Marker](../slot-marker.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000AB0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
