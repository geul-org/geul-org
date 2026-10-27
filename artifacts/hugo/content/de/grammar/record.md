---
title: "Record und TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Jeder Record beginnt mit einem 16-Bit-TAG-WORD. Prefix (3 Bit), Kind (2 Bit), Length (4 Bit) und Codec (7 Bit) legen Art und Länge des Records fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-Daten sind eine Folge von Records. Jeder Record beginnt mit einem TAG WORD.

## Record-Layout

```
TAG WORD (16 Bit)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]
[Codec-spezifischer TAG]
Payload
```

- Das TAG WORD lautet `000K KLLL LCCC CCCC`.
- Erweiterungs-TAGs stehen nur in der obigen Reihenfolge. Der Length-Erweiterungs-TAG folgt stets unmittelbar auf das TAG WORD.
- Aufbau des Codec-spezifischen TAG und des Payloads legt die jeweilige Codec-Spezifikation fest. Die Länge des Codec-spezifischen TAG steht nicht im TAG WORD, denn zur Interpretation des Payloads braucht man ohnehin das Codebook.
- Ein Codec mit Unterformaten bestimmt das Unterformat durch 1 WORD Codec-spezifischen TAG (Edge WORLD usw.).

## Byte-Reihenfolge

- Die kanonische Serialisierung ist Big-Endian.
- Bitfelder werden ab dem höchstwertigen Bit angeordnet.
- Innerhalb eines WORD steht das obere Byte zuerst, bei Werten aus mehreren WORD das obere WORD zuerst.
- Die Darstellung im Speicher bestimmt die Implementierung frei.

## Kind (2 Bit)

| Wert | Kind | TAG WORD | Definition |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Verweist auf ein Objekt. Codec und Ziel-ID identifizieren das Objekt |
| `01` | Value | `0000 1LLL LCCC CCCC` | Enthält den Wert selbst. Der Codec legt die Interpretation des Payloads fest |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Verbindet andere Records als Komponenten. Der Codec legt Rolle und Reihenfolge der Komponenten fest |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Sagt etwas über das Dokument und seine Records aus |

- Das Kind ist eine unveränderliche Eigenschaft des Codecs. Ein einmal vergebener Codec wechselt nicht das Kind.
- Value und Edge haben dasselbe Format „Codec + Payload“. Nur ein Edge hat andere Records als Komponenten.
- Bei Reference werden die 7 Codec-Bit in 4 Bit Codec und 3 Bit Quantifier aufgeteilt ([Reference](/de/grammar/reference/)).

## Length (4 Bit)

Die Length ist die **Gesamtzahl der WORD**, die der Record belegt. Sie umfasst TAG WORD, Erweiterungs-TAGs, Payload und das Padding im letzten WORD.

| Wert | Bedeutung |
|---|---|
| `0000`~`1101` | 1~14 WORD (Wert + 1) |
| `1110` | Erweiterte Länge 1: Die Gesamtzahl der WORD steht im nächsten 1 WORD (15~65.535) |
| `1111` | Erweiterte Länge 2: Die Gesamtzahl der WORD steht in den nächsten 2 WORD (65.536~2³²−1) |

- 1~14 WORD werden stets als direkte Länge geschrieben. Eine breitere Schreibweise ist nicht kanonisch.
- In der Gesamtzahl der WORD bei erweiterter Länge ist der Length-Erweiterungs-TAG selbst enthalten.
- Einen Record mit mehr als 2³²−1 WORD gibt es nicht.
- Ein 1-WORD-Record besteht nur aus dem TAG WORD, ohne Payload. Er wird nur verwendet, wenn die Codec-Spezifikation es erlaubt (z. B. Meta `BODY`, `END`, leere Bytefolge, Slot-Marker).
- Auch ohne Codebook kann man Records mit `Position des nächsten Records = Beginn des aktuellen Records + Length` überspringen.

## Codec (7 Bit)

| Wert | Name | Bedeutung |
|---|---|---|
| `0x00`~`0x7B` | Direkter Code | Das TAG WORD allein bestimmt den Codec |
| `0x7C` | ISSUER-1WORD | Im Codec-Erweiterungs-TAG: Issuer 1 WORD und Formatnummer 1 WORD |
| `0x7D` | ISSUER-2WORD | Im Codec-Erweiterungs-TAG: Issuer 2 WORD und Formatnummer 1 WORD |
| `0x7E` | ISSUER-4WORD | Im Codec-Erweiterungs-TAG: Issuer 4 WORD und Formatnummer 1 WORD |
| `0x7F` | ISSUER-16WORD | Im Codec-Erweiterungs-TAG: Issuer 16 WORD und Formatnummer 1 WORD |

- Der Codec-Nummernraum ist für jedes Kind getrennt. Dieselbe Nummer bei einem anderen Kind ist ein anderer Codec.
- Ein Codec, der kein direkter Code ist, ist ein Paar `(Issuer, Formatnummer)`. Die Formatnummer definiert der jeweilige Issuer ([Issuer und Veröffentlichung](/de/grammar/issuer/)). Erweiterte Formate stehen unter dem Issuer der Organisation, die das Format festgelegt hat.
- Ein Codec mit direktem Code wird nicht zusätzlich als Issuer-Format geführt.
- Issuer-Formate gibt es nur bei Value und Edge. Reference nutzt 4 Bit Codec, und Meta ist eine gemeinsame Spezifikation, die nur GEUL definiert.
- Die oberen Bits von Codec und Formatnummer geben die Familie (Value, Edge) oder Klasse (Meta) an. Die Familie kennt man auch ohne Codebook.
- Direkte Codes lassen sich nicht zurücknehmen. Nur nachweislich häufige Formate erhalten einen direkten Code.

## Issuer-Format-Record

```
TAG WORD          Codec = 0x7C~0x7F
[Length-Erweiterungs-TAG]
Issuer            1/2/4/16 WORD (der Codec legt die Breite fest)
Formatnummer      1 WORD. Obere Bits sind die Familie
Payload           vom Format festgelegter Wert
```

- Ein Decoder, der das Format nicht kennt, kennt nur die Familie der Formatnummer und überspringt den Payload.

## Bytefolgen variabler Länge

Bei Werten, deren Länge in Bytes angegeben wird (Text, URI, Sprach-Tag, Bytefolge unbekannter Art), werden Codec (oder Formatnummer) als **Paar gerade/ungerade** vergeben.

- Ist das niederwertigste Bit des Codec `0`, ist die Bytezahl gerade, bei `1` ungerade.
- Bytezahl = `2 × Anzahl der Payload-WORD − niederwertigstes Bit`. Es gibt kein Byte-Count-Feld.
- Bei ungerader Zahl ist das untere Byte des letzten WORD ein Padding `0x00`. Ist es nicht `0x00`, wird der Record abgelehnt.
- Eine leere Bytefolge ist ein 1-WORD-Record (nur TAG WORD) des geraden Codec.
- Werte fester Größe wie UUID, Digest und Adresse erhalten kein Paar.

## Beispiel: Ein TAG WORD lesen

Lesen wir `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

Dieser Record ist ein Edge von 10 WORD mit dem Codec TRIPLE. Auch ohne Codebook weiß man, dass der nächste Record 10 WORD später beginnt.

## Slot-Marker

Die TAG WORDs `0x0000`~`0x0007` sind 1-WORD-Records des reservierten Reference-Codec `0000`. Sie verweisen auf kein Objekt und füllen eine Stelle eines Record-Feldes ([Slot-Marker](/de/grammar/reference/slot-marker/)).

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = Markernummer
```

| WORD | Name | Bedeutung | Worüber es etwas sagt | Logik | Weltannahme | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Nicht angegeben | Dokument: Diese Stelle wurde nicht ausgefüllt | keine Behauptung | offene Welt | kein Snak |
| `0x0001` | UNKNOWN-VALUE | Unbekannt | Welt: Es gibt einen Wert. Welcher, ist unbekannt | `∃x. P(s, x)` | Existenz geschlossen, Identität offen | `somevalue` |
| `0x0002` | NO-VALUE | Kein Wert | Welt: Es gibt keinen Wert | `¬∃x. P(s, x)` | geschlossen bezüglich (s, P, einschränkende Bedingung) | `novalue` |
| `0x0003`~`0x0007` | Reserviert | | | | | |

- Beispiel: Ist „Kinder“ (P40) ABSENT, ist die Anzahl unbekannt; bei UNKNOWN-VALUE mindestens 1; bei NO-VALUE 0. Ist der Endzeitpunkt (P582) ABSENT, ist unbekannt, ob es noch gilt; bei UNKNOWN-VALUE ist es beendet, aber der Zeitpunkt unbekannt; bei NO-VALUE ist es nicht beendet.
- Die unteren 3 Bit `MMM` sind nicht der Quantifier, sondern die Markernummer (Quantifier-Ausnahme in [Reference](/de/grammar/reference/)).
- Ein Marker ist nur gültig, wenn die CODEC-Liste des Feldes genau dieses WORD enthält. Bei Wildcards, Feldern ohne CODEC, Stellen für HEAD-/BODY-Records und Stellen für Edge Ids ist er invalid ([CODEC](/de/grammar/edge/codec/)).
- Pflichten des Lesers:
  1. UNKNOWN-VALUE ist keine Wertangabe, sondern eine Existenzbehauptung. Er ist keinem Wert gleich oder ungleich, und zwei UNKNOWN-VALUE gelten untereinander nicht als derselbe Wert. TRIPLEs mit UNKNOWN-VALUE werden nicht als Duplikate zusammengeführt.
  2. NO-VALUE ist innerhalb der einschränkenden Bedingungen dieser Proposition geschlossen. Steht er mit einem Wert-TRIPLE desselben Subject, Predicate und rank zusammen, dessen einschränkende Bedingungen nicht unterscheidbar sind, ist das ein Widerspruch, und der Prüfer warnt (er lehnt nicht ab).
  3. rank gilt unverändert. Bei der Wahl des Hauptwerts (truthy) sind auch TRIPLEs mit den beiden Markern Kandidaten.
  4. Als QUALIFIER-Wert verwendet, ändert er die Bedeutung dieser Einschränkung (`P582 = UNKNOWN`: beendet, Zeitpunkt unbekannt. `P582 = NONE`: nicht beendet).
  5. ABSENT sagt nichts über die Welt aus. Ein Wert, der nicht übertragen werden konnte, wird nicht als UNKNOWN-VALUE geschrieben.

## Kanonische Form

Gleicher Inhalt muss zu gleichen Bytes werden. Nur so sind Inhaltshash und Signatur eindeutig.

- Längen werden in der kürzesten Schreibweise geschrieben (1~14 WORD als direkte Länge).
- Ganzzahlen werden in der kürzesten Breite geschrieben. Es gilt die kanonische Form der jeweiligen Codec-Spezifikation.
- Records, die nicht in kanonischer Form vorliegen, werden abgelehnt.
