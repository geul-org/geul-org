---
title: "Codec-Spezifikationsdokument"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Auch das Codebook ist ein GEUL-Dokument. Mit den vier Edges DECLARE, FIELD, ENUM und CODEC wird der Payload-Aufbau eines Codecs deklariert, und dieses eine Dokument dient zugleich der Prüfung, Zerlegung und Anzeige."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Wie ein Codec seinen Payload aufbaut, legt das Codebook fest. Das Codebook von GEUL ist kein eigenes Format, sondern ein **GEUL-Dokument**. Zu jedem Codec gibt es ein Spezifikationsdokument.

## Ort des Spezifikationsdokuments

Die Spezifikationsdokumente der direkten Codes veröffentlicht der GEUL-Issuer (`0x0000`). Die Dokument-ID ist das TAG WORD des Codecs (nur die Stellen für Kind und Codec, Length ist 0), auf 4 WORD erweitert.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Spezifikationsdokument |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

Der Decoder bildet allein aus dem TAG WORD die Adresse des Spezifikationsdokuments. Begegnet er einem unbekannten Codec, lädt und liest er dessen Dokument.

- `<TAG>` sind die 4 Hex-Stellen des TAG WORD des Ziels. Die Length-Stelle ist `0000`, bei Reference werden die Quantifier-Bits auf `000` gesetzt (LOCAL ist `0008`).
- Der Reference-Codec `0000` ist reserviert, daher gibt es kein Spezifikationsdokument mit dem Ziel-TAG-WORD `0x0000`. So überschneiden sich Spezifikationsdokumente nicht mit dem Begriffsdefinitions-Indexdokument des GEUL-Issuers (Dokument-ID `0`, [Issuer und Veröffentlichung](/de/grammar/issuer/#begriffsdefinitionsdokumente)). Auch für den [Slot-Marker](/de/grammar/reference/slot-marker/) (`0x0000`~`0x0002`) des Codecs `0000` gibt es kein Spezifikationsdokument. Er ist im Decoder eingebaut ([Ebene 0](/de/grammar/publishing/#ebenen)).
- Ein Spezifikationsdokument enthält als `DOC-ID` den DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`). Auch die Records der Versionsliste verwenden diesen DOC-POINTER.
- Wie andere Dokumente bindet auch ein Spezifikationsdokument im Namensindex `0x0000/documents.geul` des GEUL-Issuers einen kleingeschriebenen Slug-Namen. Beispiel: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)).
- Versionen, kanonische Adresse und Signaturregeln sind dieselben wie bei gewöhnlichen veröffentlichten Dokumenten.

### Dokument-ID des GEUL-Issuers

| Dokument-ID | Verwendung |
|---|---|
| `0x0000000000000000` | Begriffsdefinitions-Indexdokument |
| `0x00000000 0000xxxx` | Codec-Spezifikationsdokument. `xxxx` ist das Ziel-TAG-WORD |
| `0x0001xxxx xxxxxxxx` | Begriffsdefinitionsdokument von geul.org. Ein Dokument je Begriff ([Issuer und Veröffentlichung](/de/grammar/issuer/#begriffsdefinitionsdokumente)) |

- `0x00000000 0000xxxx` ist für Codec-Spezifikationsdokumente reserviert. Andere Dokumente des GEUL-Issuers (etwa Dokumente für GEUL-eigene ISSUER-Formate, wenn direkte Codes knapp werden) verwenden diesen Bereich nicht.

### Codebook und Spezifikationsausgabe

- Codebook-Dokumente werden nicht per `IMPORT-DOC` importiert. Welchem Codebook ein Dokument folgt, bestimmt [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/) im HEAD.
- Jeder Decoder bringt das Kern-Codebook mit oder lädt es von dieser Adresse.
- Wird ein Vorschlag (Prefix `000`) als Standard übernommen, bleibt das Layout unverändert, und nur der Prefix wechselt auf `001` ([Überblick](/de/grammar/overview/#bereichsstruktur)). Da sich das Ziel-TAG-WORD ändert, wird die übernommene Fassung ein neues Spezifikationsdokument mit anderer Dokument-ID, und das Vorschlagsdokument bleibt unverändert.

## Vier Vokabeln

| Edge | Codec | Aufgabe |
|---|---|---|
| DECLARE | `0x1B` | Deklariert den Payload-Aufbau eines Codecs. Ziel-TAG-WORD 1 WORD |
| FIELD | `0x1C` | Ein Payload-Feld. Zugehöriges DECLARE und Breite |
| ENUM | `0x1D` | Gibt einem Codewert eines Rohwert-Feldes eine Bedeutung |
| CODEC | `0x1E` | Legt ein Kind/Codec fest, das ein Feld akzeptiert |

- Die Layouts der vier Edges sind im Decoder eingebaut ([Ebene 0](/de/grammar/publishing/#ebenen)), denn Spezifikationsdokumente müssen ohne Codebook lesbar sein. Zum Lesen eines Spezifikationsdokuments braucht man kein weiteres Spezifikationsdokument.
- Namen (Codec-Name, Feldname, Name des Codewerts) werden alle per BIND gebunden.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (das DECLARE, zu dem dieses Feld gehört)
Breite            1 WORD: 0 = Record, n = Rohwert n WORD, 0xFFFF = restlicher Rohwert
```

- Die **Reihenfolge im Dokument** der FIELDs, die auf dasselbe DECLARE verweisen, ist die Reihenfolge der Payload-Felder.
- Ein Record-Feld beginnt mit einem TAG WORD und wird in dessen Length gelesen.
- Ein Rohwert-Feld ist eine vorzeichenlose Ganzzahl, die in der festgelegten WORD-Zahl gelesen wird. Werte, die eine Interpretation brauchen, wie Vorzeichen, Dezimalstellen oder Datum, sind keine Rohwerte, sondern Value-Records.
- Der restliche Rohwert (`0xFFFF`) darf nur einmal vorkommen, und danach folgen nur Rohwerte fester Breite.
- Die Edge Id eines Edge wird nicht als FIELD deklariert. Als erste Komponente jedes Edge ist sie implizit.
- Die Position nach dem Lesen aller Felder muss genau mit dem Ende des Records übereinstimmen.

### CODEC

Legt das Format fest, das ein Feld akzeptiert. Das Ziel-WORD verwendet die Stellen für Kind und Codec des TAG WORD unverändert.

| Length-Stelle | Bedeutung | Beispiel |
|---|---|---|
| `0000` | Exakter Codec | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | Wildcard: Codec-Bits, die 0 sind, passen auf alles | `0780` beliebiges Reference, `0F80` beliebiger Value, `07A0` Wikidata QID (unabhängig vom Quantifier) |

- Hat ein Record-Feld kein CODEC, akzeptiert es jeden Record (ohne Slot-Marker). Hat es eines oder mehrere, muss es einer davon sein (geschlossene Liste).
- Setzt man bei einem Rohwert-Feld ein CODEC, wird dieser Rohwert als dieser Value ohne TAG interpretiert.

### Optionale Felder und Slot-Marker

[Slot-Marker](/de/grammar/reference/slot-marker/) sind eine Gruppe von 1-WORD-Records des reservierten Reference-Codecs `0000`. Sie können nur dann an einer Stelle stehen, wenn die CODEC-Liste des Feldes dieses WORD als exaktes Ziel enthält.

| CODEC-Ziel | Marker | Dieses Feld |
|---|---|---|
| `0000` | ABSENT, nicht angegeben | ist ein **optionales Feld**. Es darf ausgelassen werden |
| `0001` | UNKNOWN-VALUE, unbekannt | akzeptiert die Behauptung, dass es einen Wert gibt, dieser aber unbekannt ist |
| `0002` | NO-VALUE, kein Wert | akzeptiert die Behauptung, dass es keinen Wert gibt |

- **Akzeptanzregel:** Ein Marker ist nur gültig, wenn dasselbe WORD in der CODEC-Liste des Feldes als exaktes Ziel steht. Wildcards (`0780`, `0781`, `0F80` …) und Felder ohne CODEC („beliebiger Record“) akzeptieren keine Marker. An Stellen für HEAD-/BODY-Records und für Edge Ids ist er invalid.
- Lässt man ein optionales Feld aus, schreibt man an dessen Stelle ein einzelnes WORD `0x0000` (ABSENT). Auch ein optionales Feld belegt immer seine Stelle. Dadurch hat jeder Record genau eine Schreibweise, und die Zerlegung ergibt sich allein aus der Position.
- Marker sind ein reservierter Reference-Codec, überschneiden sich also nicht mit anderen Records, und auch ein Decoder, der die Spezifikation nicht kennt, überspringt sie als 1-WORD-Records.
- Die drei Marker sagen Verschiedenes. ABSENT ist eine Aussage über das Dokument (diese Stelle wurde nicht ausgefüllt) und behauptet nichts über die Welt. UNKNOWN-VALUE behauptet, dass es einen Wert gibt (`∃x`), NO-VALUE, dass es keinen gibt (`¬∃x`, innerhalb der einschränkenden Bedingungen). Auslassen bedeutet nicht „kein Wert“, sondern „nicht angegeben“.
- Was ein Marker bedeutet, legt die Spezifikation des Codecs fest, der ihn akzeptiert ([TRIPLE](/de/grammar/edge/triple/), [QUALIFIER](/de/grammar/edge/qualifier/)).

## Beispiel: Spezifikationsdokument von TRIPLE

Der BODY von `0x0000/0x000000000000100A`.

| Edge | Inhalt | Name (BIND) |
|---|---|---|
| #1 DECLARE | Ziel `100A` | `TRIPLE` |
| #2 FIELD | Feld von #1, Record | `predicate` |
| #3 FIELD | Feld von #1, Record | `subject` |
| #4 FIELD | Feld von #1, Record | `object` |
| #5 FIELD | Feld von #1, Rohwert 1 WORD | `rank` |
| #6~#8 ENUM | Codewerte 0, 1, 2 von #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 wird als UNSIGNED-INTEGER (`0802`) interpretiert | |
| #18, #19 CODEC | #4 ist ein beliebiges Reference (`0780`) oder ein beliebiger Value (`0F80`) | |
| #20, #21 CODEC | #4 akzeptiert auch UNKNOWN-VALUE (`0001`) und NO-VALUE (`0002`) | |

Mit diesem einen Dokument zerlegt der Decoder einen TRIPLE-Record in Felder, zeigt ihn mit Feldnamen an und prüft, ob das Format stimmt.

## Beispiel: Spezifikationsdokument von QUANTITY

Beim Value QUANTITY (`0806`) sind alle vier Felder Records.

| Feld | CODEC |
|---|---|
| `amount` | `0801` SIGNED-INTEGER, `0802` UNSIGNED-INTEGER, `0803` BINARY-FLOAT (nur endliche Werte), `0807` FRACTION, `0810` SIGNED-DECIMAL, `0811` UNSIGNED-DECIMAL |
| `unit` | `0780` beliebiges Reference, `0000` optional |
| `lower` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (wie amount), `0000` optional |
| `upper` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (wie amount), `0000` optional |

## Regeln

- In einem Spezifikationsdokument gibt es ein DECLARE. Das Ziel des DECLARE ist gleich dem TAG WORD der Dokument-ID.
- Dasselbe Ziel wird in einem Dokument nicht zweimal deklariert.
- Varianten mit anderem Feldaufbau werden nicht als Verzweigung geschrieben. Jeder Codec wird einzeln deklariert.
- Layouts mit mehr als einem variablen Rohwert oder mit einer Rohwertbreite, die vom Wert eines anderen abhängt, lassen sich nicht deklarieren. Solche Teile werden in einen Record gekapselt.
- Spezifikationsdokumente werden wie andere Dokumente als Versionen veröffentlicht. Das Binärlayout eines Codecs wird jedoch nicht revidiert. Um es zu ändern, vergibt man einen neuen Codec.

## Offene Fragen

- Die Zuordnung vom Wert `SPEC-VERSION` (v1 ist `0x0001`) zur Version des Codebook-Dokuments. Ein Abstammungs-Meta, das übernommene Fassung und Vorschlagsfassung verbindet.
