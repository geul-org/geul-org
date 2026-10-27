---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER ist ein Beschreibungs-Edge (Codec 0x0B), das eine Bedingung anhängt, die die Proposition eines anderen Edge (vor allem eines TRIPLE) einschränkt. Als Value kann anstelle eines Wertes unbekannt (UNKNOWN-VALUE) oder kein Wert (NO-VALUE) stehen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER ist ein Beschreibungs-Edge, das eine Bedingung anhängt, die die Proposition eines anderen Edge (vor allem eines [TRIPLE](/de/grammar/edge/triple/)) einschränkt. Codec `0x0B`.

Er entspricht einem Wikidata-qualifier (Snak): eine Eigenschaft und ein Wert.

## Layout

```
TAG WORD          0001 0LLL L000 1011
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Property          Reference-Record (WIKIDATA-PID usw.)
Target            LOCAL-Reference-Record (Edge Id des eingeschränkten Edge)
Value             Reference- oder Value-Record oder Slot-Marker 0x0001 UNKNOWN-VALUE / 0x0002 NO-VALUE
```

- Die Reihenfolge der Komponenten ist wie bei TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Der Decoder liest auf demselben Weg. Die Rollen legt der Codec fest.

## Interpretation und Gültigkeit

- Property und Target sind jeweils genau ein vollständiger Reference-Record, und das Target ist ein LOCAL Reference. Das geul.org-Spezifikationsdokument setzt beim Target [CODEC](/de/grammar/edge/codec/) LOCAL (`0008`). Der Value ist genau ein vollständiger Reference- oder Value-Record oder ein [Slot-Marker](/de/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) / `0x0002` (NO-VALUE) mit 1 WORD. Das Spezifikationsdokument setzt beim Value CODEC `0780`, `0F80`, `0001` und `0002`. ABSENT (`0x0000`) wird nicht akzeptiert. Property und Target akzeptieren keine Slot-Marker. Der Cursor nach dem Lesen des Value muss mit dem Ende des Edge übereinstimmen.
- Das Target ist eine Edge Id im selben Dokument. Ein QUALIFIER steht im selben Dokument wie das Edge, das er einschränkt.
- Ist das Target das [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) im HEAD (die Quelle des gesamten Dokuments), steht auch der QUALIFIER im HEAD, hinter diesem SOURCE. Alle anderen QUALIFIER stehen im BODY. Steht ein QUALIFIER, der das HEAD-SOURCE als Target hat, im BODY, ist es invalid.
- Das Target kann auch ein anderes Edge als ein TRIPLE sein. Ein an ein [SOURCE](/de/grammar/edge/source/) angehängter QUALIFIER schränkt den Zitiervorgang ein (Abrufdatum, Stelle in der Quelle usw.). Auch die Bedeutung eines SOURCE ist die Gesamtheit aller QUALIFIER, die darauf verweisen.
- **Ein QUALIFIER ist Teil der Proposition.** Er ist keine eigene Behauptung über die Proposition, sondern schränkt die Bedingungen ein, unter denen die Proposition wahr ist. Die Bedeutung des Ziel-TRIPLE ist die Gesamtheit aller QUALIFIER, die darauf verweisen.
  - Die Quelle einer Proposition schreibt man als [SOURCE](/de/grammar/edge/source/). Eigenschaften des Quellknotens (Titel, Autor usw.) schreibt man als TRIPLE mit der Quelle als Subject.
- Zum selben Target kann es mehrere QUALIFIER derselben Property geben. Die Reihenfolge der QUALIFIER zum selben Target ist die Reihenfolge im Dokument (eine Ausnahme, bei der die Edge-Reihenfolge Bedeutung hat).

## Unbekannt und kein Wert

Ist der Value eines QUALIFIER ein Slot-Marker, ändert sich die Bedeutung dieser Einschränkung. Als Beispiel dient der Endzeitpunkt (P582).

| An das Ziel-TRIPLE angehängt | Bedeutung | Ist die Proposition noch gültig? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Endete 1974 | Nein |
| `QUALIFIER P582 #n UNKNOWN` | Beendet. Wann, ist unbekannt (Wikidata `somevalue`) | Nein |
| `QUALIFIER P582 #n NONE` | Behauptet, dass es nicht beendet ist (Wikidata `novalue`) | Ja |
| Kein QUALIFIER P582 | Unbekannt, ob beendet (offene Welt) | Unbekannt |

- Wirft man `somevalue` und `novalue` eines Wikidata-qualifier weg, wird die Proposition weiter. Ein Grenz-TRIPLE, bei dem das somevalue des Endzeitpunkts weggeworfen wurde, wird als „noch geltende Grenze“ gelesen. Deshalb überträgt man sie als Marker.
- UNKNOWN-VALUE sind untereinander nicht als derselbe Wert zu betrachten. Das Vergleichsergebnis ist unbestimmt.

## Beispiel (nicht normativ)

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Der Value ist [EDTF](/de/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Grenze (P47) zwischen Q30 (USA) und Q34266 (Russisches Kaiserreich), Endzeitpunkt unbekannt. Edge Ids `2060` und `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + Marker 1.

An das NO-VALUE-TRIPLE `#3161` für die Zentralbank (P1304) von Q30 hängt man den Zeitraum an. Es gab sie nur in den Jahren 1811~1816 nicht.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [TRIPLE](/de/grammar/edge/triple/), [SOURCE](/de/grammar/edge/source/), [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/), [EDTF](/de/grammar/value/time/edtf/), [Slot-Marker](/de/grammar/reference/slot-marker/)
