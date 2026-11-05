---
title: "Codec-Spezifikationsdokument"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Wie ein Codec seinen Payload aufbaut, legt das Codebook fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Wie ein Codec seinen Payload aufbaut, legt das Codebook fest. Das Codebook von GEUL ist kein eigenes Format, sondern ein **GEUL-Dokument**. Zu jedem Codec gibt es genau ein Spezifikationsdokument.

## Ort des Spezifikationsdokuments {#규격-문서의-위치}

Die Spezifikationsdokumente der direkten Codes veröffentlicht der GEUL-Issuer (`0x00000000`). Ein Spezifikationsdokument ist ein Codec-Dokument und hat keine Dokument-ID. Die Codec ID ist das TAG WORD des Codecs (nur Abschnitt und Codec-Stelle `C`, Length ist 0), geschrieben als 32-Bit-Wert.

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<Versions-ID>.geul
```

| Codec | TAG | Spezifikationsdokument |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

Der Decoder bildet die Adresse des Spezifikationsdokuments allein aus dem TAG WORD. Trifft er auf einen unbekannten Codec, lädt und liest er dieses Dokument.

- `<TAG>` ist das Ziel-TAG-WORD als vierstelliger Hex-Wert (Großbuchstaben). Die Length-Stelle ist `0000`. Es gibt ein Codec-Dokument pro Code. Auch das Reference-5Q-System erhält je Quantifizierungscode ein eigenes Dokument (LOCAL Identified `0050`, LOCAL Generic `0060`). Direkte Codes und Issuer-Codecs verwenden dieselbe Adressregel `<Issuer>/codecs/<Codec ID>/` ([Veröffentlichungsadresse und Versionsliste](publishing.md#공표-주소)).
- Auch [Slot-Marker](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) haben ein Spezifikationsdokument. Da sie keinen Payload haben, enthält es nur DECLARE und kein FIELD. Bedeutung und Annahmeregel der Marker sind im Decoder eingebaut ([Schicht 0](publishing.md#층)). Auch ein Codec, dessen Layout noch nicht festgelegt ist, beginnt als Spezifikationsdokument mit nur DECLARE.
- Ein Spezifikationsdokument verwendet als `DOC-ID` einen [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`). Auch der Versionslisten-Record verwendet diesen CODEC-POINTER.
- Regeln für Version, kanonische Adresse und Signatur sind dieselben wie bei allgemeinen veröffentlichten Dokumenten.

### Codebook und Spezifikationsausgabe {#코덱북과-명세-판}

- Auch ein Codec-Dokument kann mit [IMPORT-DOC](meta/0x1E4L-import-doc.md) importiert werden. Dann steht an der Dokumentstelle statt eines DOC-POINTER ein [CODEC-POINTER](reference/0x042L-codec-pointer.md). [SPEC-VERSION](meta/0x1C5L-spec-version.md) im Dokument-HEAD bestimmt, welchem Codebook das Dokument folgt.
- Jeder Decoder bringt das Kern-Codebook mit oder lädt es von dieser Adresse.
- Wird ein Vorschlag (Prefix `000`) zum Standard erhoben, bleibt das Layout unverändert, und nur der Prefix wechselt zu `001` ([Überblick](_index.md#영역-구조)). Da sich das Ziel-TAG-WORD ändert, wird die angenommene Fassung ein neues Spezifikationsdokument mit anderer Codec ID, und das Vorschlagsdokument bleibt unveränderlich bestehen.

## Vier Vokabeln {#네-어휘}

| Edge | Codec | Aufgabe |
|---|---|---|
| DECLARE | `0x0BBL` | Deklariert den Payload-Aufbau eines Codecs. Ziel-TAG-WORD, 1 WORD |
| FIELD | `0x0BCL` | Ein Payload-Feld. Zugehöriges DECLARE und Breite |
| ENUM | `0x0BDL` | Gibt einem Codewert eines Rohwert-Felds eine Bedeutung |
| CODEC | `0x0BEL` | Bestimmt ein Kind oder einen Codec, den ein Feld annimmt |

- Das Layout der vier Edges ist im Decoder eingebaut ([Schicht 0](publishing.md#층)), weil ein Spezifikationsdokument ohne Codebook lesbar sein muss. Zum Lesen eines Spezifikationsdokuments ist kein weiteres Spezifikationsdokument nötig.
- Namen (Codec-Name, Feldname, Name des Codewerts) werden alle per BIND gebunden.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (das DECLARE, zu dem dieses Feld gehört)
Breite            1 WORD: 0 = Record, n = Rohwert aus n WORD, 0xFFFF = restlicher Rohwert
```

- Die **Reihenfolge innerhalb des Dokuments** der FIELDs, die auf dasselbe DECLARE zeigen, ist die Reihenfolge der Payload-Felder.
- Ein Record-Feld beginnt mit einem TAG WORD und wird in der Länge seines Length gelesen.
- Ein Rohwert-Feld ist eine vorzeichenlose ganze Zahl, die in der festgelegten Anzahl WORD gelesen wird. Werte, die eine Interpretation brauchen, etwa Vorzeichen, Dezimalstellen oder Datum, sind kein Rohwert, sondern ein Value-Record.
- Ein restlicher Rohwert (`0xFFFF`) darf nur einmal vorkommen, und danach folgen nur Rohwerte fester Breite.
- Die Edge Id eines Edge wird nicht als FIELD deklariert. Sie ist das erste Element jedes Edge und daher implizit. EDGE-ISSUER ist das erste Element nach Issuer und Codec-Nummer ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- Die Position nach dem Lesen aller Felder muss genau mit dem Ende des Records übereinstimmen.

### CODEC {#codec}

Bestimmt das Format, das ein Feld annimmt. Das Ziel-WORD verwendet die Codec-Stelle des TAG WORD (Abschnitt `KKKK` und `C`) unverändert.

| Length-Stelle | Bedeutung | Beispiel |
|---|---|---|
| `0000` | genauer Codec | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Wildcard: unabhängig vom Wert `C` der gesamte Abschnitt `KKKK` (32 Plätze). Empfohlen ist der erste Platz des Abschnitts (`C = 0`) | `000F` ganzer Abschnitt 0, `060F` ganzer Abschnitt 3 |

- Erstreckt sich ein Kind über mehrere Abschnitte, wird CODEC für jeden Abschnitt aufgeführt. Beliebige Reference sind `000F`, `020F`, `040F`, beliebige Value sind `060F`, `080F`.
- Bei Quantifizierung-unabhängig oder bei Gruppen werden die genauen Codecs aufgeführt. Wikidata-QID (Quantifizierung-unabhängig) sind fünf: `0140`, `0150`, `0160`, `0170`, `0180`.

- Hat ein Record-Feld kein CODEC, nimmt es beliebige Records an (Slot-Marker ausgenommen). Hat es eines oder mehrere, muss es eines davon sein (geschlossene Liste).
- Wird bei einem Rohwert-Feld ein CODEC gesetzt, wird der Rohwert als dieser Value ohne TAG interpretiert.

### Optionale Felder und Slot-Marker {#선택-필드와-자리-표지}

Ein [Slot-Marker](slot-marker.md) ist eine Gruppe von 1-WORD-Records, die den ersten drei Plätzen `0x000L~0x002L` in Reference-Abschnitt 0 zugewiesen sind. Er darf nur an einer Stelle stehen, an der die CODEC-Liste des Felds genau dieses WORD als exaktes Ziel führt.

| CODEC-Ziel | Marker | Das Feld ist dann |
|---|---|---|
| `0000` | ABSENT, nicht angegeben | ein **optionales Feld**. Es darf entfallen |
| `0010` | UNKNOWN-VALUE, unbekannt | nimmt die Aussage an, dass es einen Wert gibt, dieser aber unbekannt ist |
| `0020` | NO-VALUE, kein Wert | nimmt die Aussage an, dass es keinen Wert gibt |

- **Annahmeregel:** Ein Marker ist nur gültig, wenn dasselbe WORD als exaktes Ziel in der CODEC-Liste des Felds steht. Wildcards (`000F`, `060F` …) und Felder ohne CODEC („beliebiger Record“) nehmen keine Marker an. An den Record-Stellen von HEAD und BODY sowie an der Edge-Id-Stelle ist er invalid.
- Wird ein optionales Feld ausgelassen, steht an seiner Stelle ein einzelnes WORD `0x0000` (ABSENT). Auch ein optionales Feld belegt seine Stelle immer. Daher hat ein Record nur eine Schreibweise, und die Zerlegung ergibt sich allein aus der Position.
- Ein Marker hat einen eigenen Reference-Code, überschneidet sich nicht mit anderen Records, und auch ein Decoder ohne Kenntnis der Spezifikation überspringt ihn als 1-WORD-Record.
- Die drei Marker sagen Verschiedenes. ABSENT ist eine Aussage über das Dokument (diese Stelle wurde nicht gefüllt) und behauptet daher nichts über die Welt. UNKNOWN-VALUE behauptet, dass es einen Wert gibt (`∃x`), NO-VALUE, dass es keinen Wert gibt (`¬∃x`, innerhalb einer einschränkenden Bedingung). Auslassen heißt nicht „kein Wert“, sondern „nicht angegeben“.
- Was ein Marker bedeutet, legt die Codec-Spezifikation fest, die ihn annimmt ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Beispiel: Spezifikationsdokument von TRIPLE {#예-triple-규격-문서}

Der BODY von `0x00000000/codecs/0x00000AA0`.

| Edge | Inhalt | Name (BIND) |
|---|---|---|
| #1 DECLARE | Ziel `0AA0` | `TRIPLE` |
| #2 FIELD | Feld von #1, Record | `predicate` |
| #3 FIELD | Feld von #1, Record | `subject` |
| #4 FIELD | Feld von #1, Record | `object` |
| #5 FIELD | Feld von #1, Rohwert 1 WORD | `rank` |
| #6~#8 ENUM | Codewerte 0, 1, 2 von #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 wird als UNSIGNED-INTEGER (`0620`) interpretiert | |
| #18, #22, #23, #19, #24 CODEC | #4 ist beliebige Reference (`000F`·`020F`·`040F`) oder beliebiger Value (`060F`·`080F`) | |
| #20, #21 CODEC | #4 nimmt auch UNKNOWN-VALUE (`0010`) und NO-VALUE (`0020`) an | |
| #25~#27 CODEC | #2 ist beliebige Reference (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 ist beliebige Reference (`000F`·`020F`·`040F`) | |

Mit diesem einen Dokument zerlegt ein Decoder einen TRIPLE-Record in Felder, zeigt ihn mit Feldnamen an und prüft, ob das Format stimmt.

## Beispiel: Spezifikationsdokument von QUANTITY {#예-quantity-규격-문서}

Bei Value QUANTITY (`0660`) sind alle vier Felder Records.

| Feld | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (nur endliche Werte), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` beliebige Reference, `0000` optional |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (wie amount), `0000` optional |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (wie amount), `0000` optional |

## Regeln {#규칙}

- Ein Spezifikationsdokument enthält genau ein DECLARE. Das Ziel des DECLARE ist gleich dem TAG WORD der Codec ID.
- Dasselbe Ziel wird in einem Dokument nicht zweimal deklariert.
- Varianten mit unterschiedlichem Feldaufbau werden nicht über Verzweigungen ausgedrückt. Jeder Codec wird einzeln deklariert.
- Layouts mit mehr als einem variablen Rohwert oder mit einer Rohwert-Breite, die vom Wert eines anderen abhängt, sind nicht deklarierbar. Solche Teile werden in einen Record eingepackt.
- Ein Spezifikationsdokument wird wie andere Dokumente nach Versionen veröffentlicht. Das binäre Layout eines Codecs wird jedoch nicht überarbeitet. Um es zu ändern, wird ein neuer Codec zugewiesen.

## Offene Probleme {#열린-문제}

- Die Zuordnung vom `SPEC-VERSION`-Wert (in v1 `0x0001`) zur Version des Codebook-Dokuments. Ein Abstammungs-Meta, das die angenommene Fassung mit der Vorschlagsfassung verbindet.
