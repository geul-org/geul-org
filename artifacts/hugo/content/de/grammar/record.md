---
title: "Aufbau eines Records"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "GEUL-Daten sind eine Folge von Records."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-Daten sind eine Folge von Records. Jeder Record beginnt mit einem TAG WORD.

## Record-Layout {#레코드-레이아웃}

```
TAG WORD (16 Bit)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]
[Codec-spezifische TAGs]
Payload
```

- Das TAG WORD lautet `000K KKKC CCCC LLLL`. Die oberen 4 Bit `KKKK` sind der Abschnitt `S = w >> 9`, und ein Abschnitt hat 32 Plätze. `C` ist der 5-Bit-Offset im Abschnitt `(w >> 4) & 0x1F`.
- Die TAG ID wird als `0x000L` geschrieben. Die ersten drei Stellen sind die 9-Bit-Codec-Stelle (`w >> 4`) aus Abschnitt und `C` zusammen, und `L` ist die Length-Stelle. Der tatsächliche WORD-Wert trägt an der L-Stelle eine Zahl (z. B. ist TRIPLE `0x0AAL`, und das TAG WORD eines 10-WORD-TRIPLE ist `0x0AA9`).
- Erweiterungs-TAGs stehen nur in der obigen Reihenfolge. Der Length-Erweiterungs-TAG steht immer unmittelbar nach dem TAG WORD.
- Aufbau der Codec-spezifischen TAGs und des Payload legt die jeweilige Codec-Spezifikation fest. Die Länge der Codec-spezifischen TAGs wird nicht im TAG WORD angegeben, denn zur Interpretation des Payload braucht man ohnehin das Codebook.
- Ein Codec mit Untertypen bestimmt den Untertyp durch einen Codec-spezifischen TAG von 1 WORD (Edge WORLD usw.).

## Bytereihenfolge {#바이트-순서}

- Die kanonische Serialisierung ist Big Endian.
- Bitfelder werden ab dem höchstwertigen Bit angeordnet.
- Innerhalb eines WORD steht das höhere Byte zuerst, bei Werten aus mehreren WORD das höhere WORD zuerst.
- Die Darstellung im Speicher bestimmt die Implementierung frei.

## Kind (Abschnittsbereich) {#kind-섹션-구간}

| Abschnitt | Kind | TAG ID | Definition |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Verweist auf ein Objekt. Codec und Objekt-ID identifizieren das Objekt |
| 3·4 | Value | `0x060L~0x09FL` | Enthält den Wert selbst. Der Codec bestimmt die Interpretation des Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Verbindet andere Records zu Komponenten. Der Codec bestimmt Rolle und Reihenfolge der Komponenten |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Sagt etwas über Dokument und Records aus |

- Das Kind wird allein durch den Abschnittsbereich bestimmt: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, der Rest Meta. Es gibt keine Ausnahmen.

- Das Kind ist eine unveränderliche Eigenschaft des Codecs. Ein einmal zugewiesener Codec wechselt das Kind nicht.
- Value und Edge haben dasselbe Format „Codec + Payload“. Nur Edge hat andere Records als Komponenten.
- Reference teilt Marker, Pointer, 5Q-Systeme und REFERENCE-ISSUER auf Codetabellen auf. Die Quantifizierung steckt im Systemcode. Die Quantifizierung von REFERENCE-ISSUER legt das Issuer-Dokument fest ([Reference](reference/_index.md)).

## Length (4 Bit) {#length-4비트}

Length ist die **Gesamtzahl der WORD**, die der Record belegt. Sie schließt TAG WORD, Erweiterungs-TAGs, Payload und das Padding im letzten WORD ein.

| Wert | Bedeutung |
|---|---|
| `0000`~`1101` | 1~14 WORD (Wert + 1) |
| `1110` | erweiterte Länge 1: Gesamtzahl der WORD im nächsten 1 WORD (15~65.535) |
| `1111` | erweiterte Länge 2: Gesamtzahl der WORD in den nächsten 2 WORD (65.536~2³²−1) |

- 1~14 WORD werden stets als direkte Länge geschrieben. Eine breitere Schreibweise ist nicht kanonisch.
- Die Gesamtzahl der WORD bei erweiterter Länge schließt den Length-Erweiterungs-TAG selbst ein.
- Es gibt keinen Record mit mehr als 2³²−1 WORD.
- Ein 1-WORD-Record ist ein einzelnes TAG WORD ohne Payload. Er wird nur verwendet, wenn die Codec-Spezifikation es zulässt (z. B. Meta `BODY`, `END`, leere Bytefolge, Slot-Marker).
- Auch ohne Codebook kann man Records überspringen mit `Position des nächsten Records = Beginn des aktuellen Records + Length`.

## Codec (Abschnitt und C, 9 Bit) {#codec-섹션과-c-9비트}

| TAG ID | Name | Bedeutung |
|---|---|---|
| vorderer Teil jedes Kind-Bereichs | direkter Code | Der Codec ergibt sich allein aus dem TAG WORD |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Issuer 2 WORD und Codec-Nummer 2 WORD im Codec-Erweiterungs-TAG |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Issuer 4 WORD und Codec-Nummer 2 WORD im Codec-Erweiterungs-TAG |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Issuer 16 WORD und Codec-Nummer 2 WORD im Codec-Erweiterungs-TAG |

- **Die letzten drei Plätze jedes Kind-Bereichs sind ISSUER.** Die Issuer-Breite ist durch die unteren 2 Bit von C bestimmt (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta hat kein Issuer-Format.
- Das `C` der direkten Codes gibt es für jeden Abschnitt gesondert. Auch bei gleichem `C`-Wert ist es in einem anderen Abschnitt ein anderer Codec. Die Codec ID eines direkten Codes ist das gesamte TAG WORD (L=0) und enthält daher das Kind.
- Die Codec-Nummer eines Issuers ist unabhängig vom Kind ein einziger Raum je Issuer. Der Issuer vergibt sie innerhalb seines eigenen `codecs/` überschneidungsfrei ([Veröffentlichungsadresse und Versionsliste](publishing.md#id-표기)).
- Ein Codec, der kein direkter Code ist, ist ein Paar `(Issuer, Codec-Nummer)`. Die Codec-Nummer definiert dieser Issuer ([Issuer und Veröffentlichung](issuer.md)). Erweiterungsformate stehen unter dem Issuer der Organisation, die das Format normiert hat.
- Ein Codec mit direktem Code wird nicht zusätzlich als Issuer-Format eingetragen.
- Issuer-Formate gibt es bei Reference, Value und Edge. Meta ist eine gemeinsame Spezifikation, die nur GEUL definiert.
- Der Abschnitt (`w >> 9`) eines Edge-Direktcodes ist die Familie. Value-Direktcodes und Meta drücken Familie und Klasse nicht durch Bits aus. Die Bedeutung der Codec-Nummer legt der Issuer fest.
- Direkte Codes können nicht zurückgenommen werden. Nur Formate, deren Häufigkeit bestätigt ist, kommen in direkte Codes.

## Issuer-Format-Record {#issuer-형식-레코드}

```
TAG WORD          ISSUER-Code (die letzten drei Plätze jedes Kind-Bereichs)
[Length-Erweiterungs-TAG]
Issuer            2/4/16 WORD (der Codec bestimmt die Breite)
Codec-Nummer      2 WORD. Vom Issuer definiert
Payload           Wird vom Codec-Dokument des Issuers festgelegt
```

- Das Layout ist bei allen drei Kinds gleich. Reichen die Nummern nicht, lässt man einen weiteren Issuer ausstellen.
- Der Payload von Edge (EDGE-ISSUER) beginnt wie bei anderen Edges mit der Edge Id. Die Reihenfolge ist daher TAG, Issuer, Codec-Nummer, Edge Id, übriger Payload.
- Ein Decoder, der das Format nicht kennt, kennt Issuer und Codec-Nummer und überspringt mit Length.

## Bytefolge variabler Länge {#가변-길이-바이트열}

Bei Werten, deren Länge in Bytes gemessen wird, wie Text, URI, Sprach-Tag oder unbekannte Bytefolge, werden Codec (oder Codec-Nummer) als **Gerade/Ungerade-Paar** zugewiesen.

- Ist das niedrigstwertige Bit des Codecs (bei direkten Codes das niedrigstwertige Bit von C) `0`, ist die Byteanzahl gerade, bei `1` ungerade.
- Byteanzahl = `2 × Anzahl der Payload-WORD − niedrigstwertiges Bit`. Es gibt kein Byte-Count-Feld.
- Bei ungerader Anzahl ist das untere Byte des letzten WORD ein Padding `0x00`. Ist es nicht `0x00`, wird abgelehnt.
- Eine leere Bytefolge ist ein 1-WORD-Record (nur TAG WORD) des geraden Codecs.
- Für Werte fester Größe wie UUID, Digest oder Adresse gibt es kein Paar.

## Beispiel: TAG WORD lesen {#예-tag-word-읽기}

Lesen wir `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, Abschnitt 0101 (5, Edge), C 01010, Codec 0x0AAL (TRIPLE), Length 1001 (10 WORD)
```

Dieser Record ist ein Edge von 10 WORD, und der Codec ist TRIPLE. Auch ohne Codebook weiß man, dass der nächste Record 10 WORD später liegt.

## Slot-Marker {#자리-표지}

Die TAG WORD `0x0000`, `0x0010` und `0x0020` sind 1-WORD-Records der Reference-Slot-Marker. Sie verweisen auf kein Objekt und füllen die Stelle eines Record-Felds ([Slot-Marker](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, Abschnitt 0 (Reference), C 0~2, LLLL 0000 (1 WORD)
```

| WORD | Name | Bedeutung | Worüber es etwas sagt | Logik | Weltannahme | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | nicht angegeben | Dokument: Diese Stelle wurde nicht gefüllt | keine Behauptung | offene Welt | kein snak |
| `0x0010` | UNKNOWN-VALUE | unbekannt | Welt: Es gibt einen Wert. Welcher, ist unbekannt | `∃x. P(s, x)` | Existenz geschlossen, Identität offen | `somevalue` |
| `0x0020` | NO-VALUE | kein Wert | Welt: Es gibt keinen Wert | `¬∃x. P(s, x)` | geschlossen für (s, P, einschränkende Bedingung) | `novalue` |

- Beispiel: Ist bei Kindern (P40) ABSENT angegeben, ist die Zahl unbekannt, bei UNKNOWN-VALUE mindestens 1, bei NO-VALUE 0. Ist beim Endzeitpunkt (P582) ABSENT angegeben, ist unbekannt, ob es noch gilt, bei UNKNOWN-VALUE ist es beendet, aber der Zeitpunkt ist unbekannt, bei NO-VALUE ist es nicht beendet.
- Ein Marker ist nur gültig, wenn die CODEC-Liste des Felds dieses WORD exakt führt. Bei Wildcards, Feldern ohne CODEC, den Record-Stellen von HEAD und BODY sowie der Edge-Id-Stelle ist er invalid ([CODEC](edge/0x0BEL-codec.md)).
- Pflichten der lesenden Seite:
  1. UNKNOWN-VALUE ist keine Wertangabe, sondern die Behauptung einer Existenz. Es ist weder gleich noch ungleich irgendeinem Wert, und zwei UNKNOWN-VALUE werden auch untereinander nicht als gleicher Wert betrachtet. Ein TRIPLE mit UNKNOWN-VALUE wird nicht als Duplikat zusammengeführt.
  2. NO-VALUE ist innerhalb der einschränkenden Bedingung dieser Proposition geschlossen. Steht es bei gleichem Subject, Predicate und rank zusammen mit einem Wert-TRIPLE, dessen einschränkende Bedingung nicht unterscheidbar ist, ist das ein Widerspruch, und der Prüfer warnt (er lehnt nicht ab).
  3. rank gilt unverändert. Beim Wählen des repräsentativen Werts (truthy) sind auch TRIPLE mit den beiden Markern Kandidaten.
  4. Wird es als QUALIFIER-Wert verwendet, ändert es die Bedeutung dieser Einschränkung (`P582 = UNKNOWN`: beendet, Zeitpunkt unbekannt. `P582 = NONE`: nicht beendet).
  5. ABSENT sagt nichts über die Welt aus. Ein nicht übertragener Wert wird nicht als UNKNOWN-VALUE geschrieben.

## Kanonische Form {#정규형}

Gleicher Inhalt muss zu gleichen Bytes werden. Nur so sind Inhaltshash und Signatur eindeutig.

- Für die Länge wird die kürzeste Schreibweise verwendet (1~14 WORD als direkte Länge).
- Ganze Zahlen werden in der schmalsten Breite geschrieben. Es gilt die kanonische Form, die die jeweilige Codec-Spezifikation festlegt.
- Records, die nicht kanonisch sind, werden abgelehnt.
- Ausnahme: `L=1111` im Ziel-WORD von [CODEC](edge/0x0BEL-codec.md) betrachtet unabhängig vom `C`-Wert nur den Abschnitt `KKKK`. Der erste Platz des Abschnitts (`C = 0`) wird empfohlen, aber ein anderes `C` im selben Abschnitt wird nicht abgelehnt.
