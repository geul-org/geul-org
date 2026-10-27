---
title: "GEUL-Grammatik"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Die Grammatikspezifikation von GEUL v1. Sie definiert Records auf 16-Bit-Wörtern, die vier Kinds und alle Codecs, die Dokumentstruktur sowie Issuer und Veröffentlichungsregeln."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Dies ist die Grammatikspezifikation von GEUL v1. Wer sie zum ersten Mal liest, folgt dieser Reihenfolge.

1. [Überblick](/de/grammar/overview/) — Was GEUL ist und nach welchen Prinzipien es entworfen wurde
2. [Record und TAG WORD](/de/grammar/record/) — 16-Bit-TAG-WORD, Kind, Length, Codec
3. [Dokument](/de/grammar/document/) — HEAD und BODY, Inhaltshash, Version und Revision
4. [Reference](/de/grammar/reference/), [Value](/de/grammar/value/), [Edge](/de/grammar/edge/), [Meta](/de/grammar/meta/) — die vier Kinds
5. [Issuer und Veröffentlichung](/de/grammar/issuer/) — Wer Dokumente und Formate herausgibt, die 1-WORD-Zuweisungstabelle, Offenlegung, Signatur und Prüfschlüssel
6. [Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/) — ID-Notation, Veröffentlichungsadresse, Formatangabe, Namensindex, Versionsliste, Vertrauensebenen
7. [Codec-Spezifikationsdokument](/de/grammar/codec-spec/) — Wie man ein Codec-Layout als GEUL-Dokument schreibt
8. [Beispiel: Wikidata-Eintrag](/de/grammar/example/) — Ein vollständiges Dokument

Diese Seite ist der Index aller Codecs. Ein Klick auf einen Namen führt zum Detaildokument des Codecs. Namen ohne Link haben noch kein Detaildokument. Direkte Codes, die nicht in den Tabellen stehen, sind reserviert.

## Kind

Das TAG WORD lautet `000K KLLL LCCC CCCC`. `KK` ist das Kind, `LLLL` die Length, `CCC CCCC` der 7-Bit-Codec. Bei Reference sind es jedoch 4 Bit Codec und 3 Bit Quantifier.

| Wert | Kategorie | Beschreibung |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/de/grammar/reference/) | Record, der auf ein Objekt verweist. `QQQ` ist der Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/de/grammar/value/) | Wert-Record |
| `0001 0LLL LCCC CCCC` | [Edge](/de/grammar/edge/) | Aufbau-Record |
| `0001 1LLL LCCC CCCC` | [Meta](/de/grammar/meta/) | Record über das Dokument und seine Records |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/de/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Name | Kategorie | Ziel-ID |
|---|---|---|---|
| `0000` | [Slot-Marker](/de/grammar/reference/slot-marker/) | Reserviert | Gruppe von 1-WORD-Markern, die nicht auf ein Objekt verweisen. Die unteren 3 Bit sind die Markernummer (siehe Tabelle unten) |
| `0001` | [LOCAL](/de/grammar/reference/local/) | Deklaration | Von diesem Dokument vergebene ID |
| `0010` | [GEUL](/de/grammar/reference/geul/) | Deklaration | Von geul.org unter CC0 vergebene Entität. Kleine Nummern werden häufig verwendeten Entitäten zugewiesen |
| `0011` | [GEUL-SIDX](/de/grammar/reference/geul-sidx/) | Deklaration | GEUL SIDX (Semantic-aligned Index). Eine Kennung, deren Bits Bedeutung tragen |
| `0100` | [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) | Deklaration | Wikidata-Eintrag. Die ganze Zahl nach `Q` |
| `0101` | [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/) | Deklaration | Wikidata-Eigenschaft. Die ganze Zahl nach `P` |
| `0110` | [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) | Zeiger-Deklaration | Der Issuer selbst. Der Payload besteht nur aus dem Issuer (1/2/4/16 WORD); es gibt keine Ziel-ID |
| `0111` | [DOC-POINTER](/de/grammar/reference/doc-pointer/) | Zeiger-Deklaration | Eine Version eines Issuer-Dokuments. Issuer + Dokument-ID 4 WORD + Versions-ID 2 WORD, keine Ziel-ID |
| `1000` | [EXTERNAL-POINTER-1WORD](/de/grammar/reference/external-pointer/) | Zeiger | LOCAL ID eines per `IMPORT-DOC` importierten Dokuments. IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/de/grammar/reference/external-pointer/) | Zeiger | Wie oben. IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/de/grammar/reference/external-pointer/) | Zeiger | Wie oben. IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/de/grammar/reference/external-pointer/) | Zeiger | Wie oben. IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/de/grammar/reference/external-issuer/) | Zeiger-Deklaration | LOCAL ID eines Dokuments eines 1-WORD-Issuers |
| `1101` | [EXTERNAL-ISSUER-2WORD](/de/grammar/reference/external-issuer/) | Zeiger-Deklaration | LOCAL ID eines Dokuments eines 2-WORD-Issuers |
| `1110` | [EXTERNAL-ISSUER-4WORD](/de/grammar/reference/external-issuer/) | Zeiger-Deklaration | LOCAL ID eines Dokuments eines 4-WORD-Issuers |
| `1111` | [EXTERNAL-ISSUER-16WORD](/de/grammar/reference/external-issuer/) | Zeiger-Deklaration | LOCAL ID eines Dokuments eines 16-WORD-Issuers |

### Slot-Marker (Codec `0000`)

`0000 0000 0000 0MMM` — [Slot-Marker](/de/grammar/reference/slot-marker/). Er steht nur dann an einer Stelle, wenn die CODEC-Liste des Feldes genau dieses WORD enthält.

| WORD | Name | Bedeutung | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/de/grammar/reference/slot-marker/) | Nicht angegeben. Ein optionales Feld wurde ausgelassen. Es wird nichts über die Welt behauptet | kein Snak |
| `0x0001` | [UNKNOWN-VALUE](/de/grammar/reference/slot-marker/) | Unbekannt. Ein Wert existiert, ist aber nicht bekannt | `somevalue` |
| `0x0002` | [NO-VALUE](/de/grammar/reference/slot-marker/) | Kein Wert. Es gibt keinen Wert | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Name | Bedeutung | Beispiel |
|---|---|---|---|
| `000` | Identified | Identifizierte Entität | Elon Musk, Deutschland |
| `001` | Generic | Allgemeine, definierende Aussage über eine ganze Art. Ausnahmen sind zulässig. | Soldaten gehorchen Befehlen |
| `010` | Free-choice | Ein beliebiges Objekt, das die Bedingung erfüllt | irgendein Soldat |
| `011` | Universal | Alle Objekte im gegebenen Bereich | alle Soldaten |
| `100` | Variable | Diskursvariable | dieser Mann, diese Frau |
| `101`~`111` | Reserved |  |  |

- Bei Codec `0000` (Slot-Marker) sind die unteren 3 Bit nicht der Quantifier, sondern die Markernummer.

## Issuer

Ein Issuer ist die Instanz, die Dokumente und Formate definiert — [Issuer und Veröffentlichung](/de/grammar/issuer/)

| Stelle | Bedeutung |
|---|---|
| ISSUER-Codes von Value und Edge (`0x7C`~`0x7F`) | Das von diesem Issuer definierte Format |
| Meta `DOC-ID` | Der Issuer, der dieses Dokument herausgegeben hat |
| Meta `IMPORT-DOC` | Der Issuer, der das importierte Dokument herausgegeben hat |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | Der Issuer, der das referenzierte Dokument herausgegeben hat (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Der referenzierte Issuer selbst (1/2/4/16 WORD) |

| Issuer-Breite | Vergabe |
|---|---|
| 1 WORD | geul.org weist sie Normungsorganisationen und wichtigen Institutionen zu ([1-WORD-Zuweisungstabelle](/de/grammar/issuer/#1-word-zuweisungstabelle)). |
| 2 WORD | Registrierung bei geul.org. Issuer mit Nachweis des Domainbesitzes (z. B. company.com) |
| 4 WORD | Registrierung bei geul.org. Issuer, die ohne Besitznachweis registriert wurden |
| 16 WORD | Selbst ausgestellt. Ohne Registrierung aus dem öffentlichen Schlüssel berechnet. Es gelten die untenstehenden Erzeugungsregeln. |

### Signaturalgorithmus des 16-WORD-Issuers

| Signaturalgorithmus-ID | Algorithmus |
|---|---|
| `0x0001` | Ed25519 |
| andere | reserviert |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/de/grammar/edge/)

Die oberen 2 Bit des Codec bilden die Familie. Direkte Codes (7 Bit) und ISSUER-Formatnummern (16 Bit) folgen derselben Regel.

| Obere 2 Bit | Familie | Direkter Code | Formatnummer |
|---|---|---|---|
| `00` | Beschreibung | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | Beleg | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | Ausführung | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/de/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Beschreibung (`00`)

| CCCCC | Codec | Name | Unterformat | Beschreibung |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/de/grammar/edge/reference-node/) |  | Gerichtete Bindung, in der ein Reference als Subject auf ein Object verweist |
| `00001` | `0x01` | [SAME-NODE](/de/grammar/edge/same-node/) |  | Identität: Zwei Reference verweisen auf dasselbe Objekt |
| `00010` | `0x02` | [DIFFERENT-NODE](/de/grammar/edge/different-node/) |  | Nicht-Identität: Zwei Reference verweisen auf verschiedene Objekte |
| `00011` | `0x03` | [BIND](/de/grammar/edge/bind/) |  | Bindet an das Subject einen maschinengerechten Namen (`UTF8-TEXT-*`). Er ist im Geltungsbereich eindeutig, muss exakt übereinstimmen und hat keine Sprache |
| `00100` | `0x04` | [LABEL](/de/grammar/edge/label/) |  | Verbindet das Subject mit seinem Sprachnamen (Label). Das Object ist UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/de/grammar/edge/alias/) |  | Verbindet das Subject mit einem weiteren Namen (Alias). Das Layout ist wie bei LABEL |
| `00110` | `0x06` | [DESCRIPTION](/de/grammar/edge/description/) |  | Verbindet das Subject mit seiner Sprachbeschreibung (Description). Das Layout ist wie bei LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Verkürzte Verbaussage |
| `01001` | `0x09` | VERB |  | Verbaussage |
| `01010` | `0x0A` | [TRIPLE](/de/grammar/edge/triple/) |  | Proposition in der Reihenfolge Predicate, Subject, Object mit rank. Das Object ist ein Wert oder ein Marker UNKNOWN-VALUE/NO-VALUE. Die Bedeutung ist die Gesamtheit aller QUALIFIER, die auf diese Edge Id verweisen |
| `01011` | `0x0B` | [QUALIFIER](/de/grammar/edge/qualifier/) |  | Eine Bedingung, die die Proposition eines anderen Edge einschränkt. Property, Target (Edge Id), Value (Wert oder Marker UNKNOWN-VALUE/NO-VALUE). Sie ist Teil der Proposition |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | vorhanden | Struktur zur Darstellung von Weltmodellen |
| `10001` | `0x11` | TIMELINE | vorhanden | Struktur zur Darstellung der Reihenfolge von Welten und Ereignissen |
| `10010` | `0x12` | SCENE | vorhanden | Szenenstruktur zur Beschreibung von Szenarien |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/de/grammar/edge/publication/) |  | Veröffentlichung eines Dokuments. DOC-POINTER, Inhaltshash |
| `11001` | `0x19` | DEPRECATION |  | Deprecation einer veröffentlichten Version. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Löschung (Grabstein) einer veröffentlichten Version. DOC-POINTER, Begründungskategorie |
| `11011` | `0x1B` | [DECLARE](/de/grammar/edge/declare/) |  | Deklaration des Payload-Aufbaus eines Codecs. Ziel-Kind und -Codec |
| `11100` | `0x1C` | [FIELD](/de/grammar/edge/field/) |  | Ein Payload-Feld. Zugehöriges DECLARE, Breite: Record (Length des TAG) oder Rohwert n WORD |
| `11101` | `0x1D` | [ENUM](/de/grammar/edge/enum/) |  | Ein Codewert eines Rohwert-Feldes. Feld, Codewert |
| `11110` | `0x1E` | [CODEC](/de/grammar/edge/codec/) |  | Ein Kind/Codec, den ein Feld akzeptiert. Feld, Ziel-WORD (`000K KLLL LCCC CCCC`, LLLL 0000 exakt, 1111 Wildcard; Slot-Marker nur als exaktes Ziel `0000`~`0002`). Record-Felder haben mehrere (geschlossene Liste), Rohwert-Felder genau einen (diesen Value ohne TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| Obere 2 Bit von CCCCC | Gruppe |
|---|---|
| `00` | Verweis und Name |
| `01` | Proposition |
| `10` | Struktur |
| `11` | Sonstiges |

### Beleg (`01`)

| Codec | Name | Unterformat | Beschreibung |
|---|---|---|---|
| `0x20` | [SOURCE](/de/grammar/edge/source/) |  | Verbindet einen Record oder das gesamte Dokument mit seiner Quelle. Target (Edge Id im BODY; im HEAD `0` = gesamtes Dokument), Origin (Reference, ABSENT oder UNKNOWN-VALUE). Die Eigenschaften der Quelle stehen in einem TRIPLE mit der Quelle als Subject, die Eigenschaften des Zitats (Abrufdatum, Stelle, Hash des Originals) in QUALIFIER, die an das SOURCE angehängt werden. SOURCE und QUALIFIER für das gesamte Dokument stehen im HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- Bereich im Originaltext, erzeugende Instanz, Konfidenz, Geltungszeitraum je Artikel und frühere Records schreibt man als QUALIFIER; die Version, in der etwas zuerst auftauchte, wird aus der Versionshistorie berechnet ([SOURCE](/de/grammar/edge/source/#darstellung-weiterer-belege)).

### Ausführung (`10`)

| CCCCC | Codec | Name | Beschreibung |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Funktionsdeklaration. Symbol, Parameter-Symbolliste, Rückgabetyp, Rumpf (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Typdeklaration. Symbol und Aufbau (Feld-Symbolliste, Aufzählungswerte, Alias-Ziel) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Konstanter Ausdruck. Ein eingebetteter Value |
| `01001` | `0x49` | UNARY | Unärer Ausdruck. Operator 1 WORD, Operand |
| `01010` | `0x4A` | BINARY | Binärer Ausdruck. Operator 1 WORD, links, rechts |
| `01011` | `0x4B` | CALL | Aufruf. Zielfunktion, Argumentanzahl, Argument × Argumentanzahl |
| `01100` | `0x4C` | MEMBER | Memberzugriff. Ziel, Feldsymbol |
| `01101` | `0x4D` | INDEX | Indexzugriff. Ziel, Index |
| `01110` | `0x4E` | CONSTRUCT | Erzeugung zusammengesetzter Werte (Liste, Record). Typ, Elementanzahl, Element × Elementanzahl |
| `01111` | `0x4F` | CONDITIONAL | Bedingter Ausdruck. Bedingung, Wert bei wahr, Wert bei falsch |
| `10000` | `0x50` | BLOCK | Geordnete Gruppe von Anweisungen. Anzahl der Anweisungen, Anweisung × Anzahl |
| `10001` | `0x51` | ASSIGN | Zuweisung. Ziel (Symbol, MEMBER, INDEX), Wert |
| `10010` | `0x52` | IF | Bedingte Verzweigung. Bedingung, BLOCK bei wahr, falsch (BLOCK/IF, 0 wenn keiner) |
| `10011` | `0x53` | SWITCH | Mehrfachverzweigung. Ziel, Anzahl der Zweige, (Wert, BLOCK) × Zweiganzahl, Standard-BLOCK (0 wenn keiner) |
| `10100` | `0x54` | WHILE | Bedingte Schleife. Bedingung, Rumpf-BLOCK |
| `10101` | `0x55` | FOREACH | Iterationsschleife. Elementsymbol, Ziel, Rumpf-BLOCK |
| `10110` | `0x56` | JUMP | Schleifensteuerung. Art 1 WORD (break, continue), Zielschleife |
| `10111` | `0x57` | RETURN | Rückgabe. Wert (0 wenn keiner) |
| `11000` | `0x58` | RAISE | Fehler auslösen. Fehlerwert |
| `11001` | `0x59` | TRY | Fehlerbehandlung. Rumpf-BLOCK, Fehlersymbol, Behandlungs-BLOCK, Abschluss-BLOCK (0 wenn keiner) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| Obere 2 Bit von CCCCC | Gruppe |
|---|---|
| `00` | Deklaration |
| `01` | Ausdruck |
| `10` | Anweisung |
| `11` | Fehler |

### TOULMIN (`11`)

Details: [TOULMIN](/de/grammar/edge/toulmin/)

| CCCCC | Codec | Name | Beschreibung |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/de/grammar/edge/toulmin/node/) | Fall-Deklaration. Ein Urteilsgraph aus Knoten und Beziehungen |
| `00001` | `0x61` | [PREDICATE-DECLARE](/de/grammar/edge/toulmin/expr/) | Prädikat-Deklaration. Urteilsfunktion/-ausdruck, Beurteilungskriterium (Spec), Faktenvertrag (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/de/grammar/edge/toulmin/node/) | Deklaration eines Beurteilungskriteriums. Konstante/Liste (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/de/grammar/edge/toulmin/node/) | Deklaration einer Behauptung. Setzt ein Prädikat in einem Fall als allgemeine Regel (Warrant). Kann angegriffen werden. |
| `00100` | `0x64` | [COUNTER-DECLARE](/de/grammar/edge/toulmin/node/) | Deklaration einer Gegenbehauptung. Greift mit eigener Schlussfolgerung an. Standard-Level ist Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/de/grammar/edge/toulmin/node/) | Deklaration einer Ausnahme. Greift ohne eigene Schlussfolgerung an. Standard-Level ist Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/de/grammar/edge/toulmin/link/) | Angriffsbeziehung. Das Urteil des Angreifers mindert das Urteil des Ziels schrittweise. |
| `01001` | `0x69` | [SUPERSEDES](/de/grammar/edge/toulmin/link/) | Verdrängungsbeziehung. Ist der Angreifer Active, nimmt er das Ziel endgültig aus der Aggregation. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Vorrangkette `A > B > C`. Kurzform paarweiser SUPERSEDES. Layout offen |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/de/grammar/edge/toulmin/link/) | Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG). |
| `10001` | `0x71` | [DO](/de/grammar/edge/toulmin/link/) | Aktion, die ausgeführt wird, wenn der Knoten Active ist |
| `10010` | `0x72` | [DO-ONCE](/de/grammar/edge/toulmin/link/) | Aktion, die auch bei Wiederholungen nur einmal ausgeführt wird |
| `10011` | `0x73` | [UNDO](/de/grammar/edge/toulmin/link/) | Kompensationsaktion zu DO (Saga). Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt. |
| `10100` | `0x74` | [CHECKING](/de/grammar/edge/toulmin/link/) | Verbindung, die ohne Nebenwirkung nur urteilt |
| `10101` | `0x75` | [ENTRY](/de/grammar/edge/toulmin/node/) | Externer Einstiegspunkt. Führt einen Fall aus oder beurteilt ihn |
| `10110` | `0x76` | [TRIGGER](/de/grammar/edge/toulmin/node/) | Ereignis- oder periodischer Einstiegspunkt ohne externen Aufruf |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Urteilsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Urteilswert, Activated, Excluded, Level. Layout offen. Das Urteil über das gesamte Dokument ist Meta [VERDICT](/de/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Beweis eines Urteils. Stelle, erwarteter Wert, tatsächlicher Wert (Fact). Layout offen |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Vom Issuer definiertes Format |

| Obere 2 Bit von CCCCC | Gruppe |
|---|---|
| `00` | Deklaration |
| `01` | Beziehung |
| `10` | Ausführung |
| `11` | Ergebnis (`0x7C`~`0x7F` sind ISSUER) |

### Edge-ISSUER-Formate

Nach `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) stehen im Codec-Erweiterungs-TAG der Issuer und die Formatnummer. Die oberen 2 Bit der Formatnummer bilden die Familie. Der Formatnummernraum ist von dem der Values getrennt.

| Issuer | Formatnummer | Name | Familie | Beschreibung |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/de/grammar/edge/toulmin/source/) | TOULMIN | Verfasster Originaltext. SPAN-Breite und UTF8-Value |
| `0x0000` GEUL | `0xC001` | [TEXT](/de/grammar/edge/toulmin/source/) | TOULMIN | Name/Zeichenkette |
| `0x0000` GEUL | `0xC002` | [SECTION](/de/grammar/edge/toulmin/source/) | TOULMIN | Abschnittsbeginn. Abschnittscode |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/de/grammar/edge/toulmin/source/) | TOULMIN | Beginn eines Fallbereichs |
| `0x0000` GEUL | `0xC004` | [CASE-END](/de/grammar/edge/toulmin/source/) | TOULMIN | Ende eines Fallbereichs |
| `0x0000` GEUL | `0xC005` | [PROSE](/de/grammar/edge/toulmin/source/) | TOULMIN | Beschreibender Absatz (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/de/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/de/grammar/edge/toulmin/node/) | TOULMIN | NODE. Funktionsreferenz |
| `0x0000` GEUL | `0xC012` | [FIELD](/de/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/de/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/de/grammar/edge/toulmin/node/) | TOULMIN | NODE. Geordnete Ausführungsgruppe |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Fall → Feld |
| `0x0000` GEUL | `0xC021` | [MEANS](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Definitionseintrag → Wert/Typ |
| `0x0000` GEUL | `0xC022` | [HAS](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Definitionseintrag → Feld |
| `0x0000` GEUL | `0xC023` | [RUNS](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Einstiegspunkt → Fall, Ausführung |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Einstiegspunkt → Fall, Beurteilung |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → Fall |
| `0x0000` GEUL | `0xC026` | [UNTIL](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → Fall (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Knoten → globale Kennung |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Alias → Pfad (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/de/grammar/edge/toulmin/link/) | TOULMIN | LINK. Knoten → TEXT, Namensangabe |

## Value

`0000 1LLL LCCC CCCC` — [Value](/de/grammar/value/)

Die oberen 2 Bit des Codec bilden die Familie. NUMERIC/DECIMAL werden über das dritte Bit weiter unterteilt (`000` NUMERIC, `001` DECIMAL).

| Obere 2 Bit | Familie | Direkter Code | Formatnummer |
|---|---|---|---|
| `00` | [NUMERIC](/de/grammar/value/numeric/)/[DECIMAL](/de/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/de/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/de/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/de/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Direkte Codes

| Codec | Name | Familie | Beschreibung |
|---|---|---|---|
| `0x00` | [BOOL](/de/grammar/value/numeric/bool/) | NUMERIC | Festes 1 WORD: false oder true |
| `0x01` | [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/) | NUMERIC | Vorzeichenbehaftete Ganzzahl im Zweierkomplement mit minimaler WORD-Zahl |
| `0x02` | [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/) | NUMERIC | Ganzzahl als Big-Endian-Unsigned-Magnitude mit minimaler WORD-Zahl |
| `0x03` | [BINARY-FLOAT](/de/grammar/value/numeric/binary-float/) | NUMERIC | IEEE-754-Skalar binary16/32/64/128 mit Payload 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/de/grammar/value/numeric/coordinate-earth/) | NUMERIC | Breite und Länge der Erde (WGS 84) als binary64, Unsicherheit als binary32 und deren Einheit als Reference (ABSENT = unbekannt) |
| `0x05` | [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/) | NUMERIC | Himmelskörper-Reference, Breite und Länge als binary64, Unsicherheit als binary32 und deren Einheit als Reference |
| `0x06` | [QUANTITY](/de/grammar/value/numeric/quantity/) | NUMERIC | numerischer Value als amount (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheit als Reference, untere/obere Schranke. Einheit und Schranken können ausgelassen werden (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/de/grammar/value/numeric/fraction/) | NUMERIC | Bruch, der die ursprüngliche Schreibweise wahrt: Zähler Ganzzahl oder Dezimalzahl, Nenner vorzeichenlose Ganzzahl oder Dezimalzahl. Nicht gekürzt |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` aus vorzeichenbehaftetem Exponent `E` und Koeffizient `C` im Zweierkomplement mit minimaler WORD-Zahl |
| `0x11` | [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` aus vorzeichenbehaftetem Exponent `E` und vorzeichenlosem Koeffizient `C` mit minimaler WORD-Zahl |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) | TIME | Vorzeichenbehaftete Tageszahl relativ zum proleptischen gregorianischen `1970-01-01` |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/de/grammar/value/time/civil-time-nanoseconds/) | TIME | Vorzeichenlose Nanosekundenzahl seit Mitternacht des bürgerlichen Tages |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/) | TIME | Vorzeichenbehaftete Sekundenzahl seit der Unix/POSIX-Epoche |
| `0x23` | [DURATION-SECONDS](/de/grammar/value/time/duration-seconds/) | TIME | Vorzeichenbehaftete SI-Sekunden-Dauer ohne Epoche |
| `0x24`/`0x25` | [EDTF](/de/grammar/value/time/edtf/) | TIME | EDTF-Datumszeichenkette (ISO 8601-2). Gerade/ungerade Bytezahl. Datumsangaben, die als GREGORIAN-DATE darstellbar sind, werden nicht so geschrieben |
| `0x26`/`0x27` | [GEDCOM-DATE](/de/grammar/value/time/gedcom-date/) | TIME | Zeichenkette eines GEDCOM-7-Datumswerts. Bewahrt die Originalnotation anderer Kalender (z. B. Julianisch). Gerade/ungerade Bytezahl |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/de/grammar/value/text/utf8-text/) | TEXT | Gültige UTF-8-Bytefolge ohne implizierte Normalisierung. Gerade Bytezahl |
| `0x41` | [UTF8-TEXT-ODD](/de/grammar/value/text/utf8-text/) | TEXT | Wie oben. Ungerade Bytezahl |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/de/grammar/value/text/uri/) | TEXT | ASCII-Bytefolge nach der `URI`-Produktion von RFC 3986. Gerade Bytezahl |
| `0x45` | [URI-ODD](/de/grammar/value/text/uri/) | TEXT | Wie oben. Ungerade Bytezahl |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/de/grammar/value/text/language-bcp47-code/) | TEXT | ASCII-Bytefolge eines vollständigen BCP-47-Language-Tags in kanonischer Schreibung. Gerade Bytezahl |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/de/grammar/value/text/language-bcp47-code/) | TEXT | Wie oben. Ungerade Bytezahl |
| `0x48` | [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/) | TEXT | Komprimierter GEUL-Primary-Language-Code mit festem Payload 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/) | TEXT | Text mit Sprache. Sprach-Value-Record (LANGUAGE-SHORT-CODE oder LANGUAGE-BCP47-CODE) und UTF-8-Bytes. Gerade/ungerade Bytezahl des Textes |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/de/grammar/value/binary/uuid/) | BINARY | RFC-9562-UUID mit 128 Bit und festem Payload 8 WORD |
| `0x61` | [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/) | BINARY | SHA-256-Ergebnis mit festem Payload 16 WORD |
| `0x62` | [SHA1-DIGEST](/de/grammar/value/binary/sha1-digest/) | BINARY | SHA-1-Ergebnis mit festem Payload 10 WORD. Nur für Identifikationszwecke wie git-Objekt-IDs |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Vom Issuer definiertes Format. Siehe unten „Value-ISSUER-Formate“ |

### Value-ISSUER-Formate

Nach `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) stehen im Codec-Erweiterungs-TAG der Issuer und die Formatnummer. Die oberen 2 Bit der Formatnummer bilden die Familie.

| Issuer | Formatnummer | Name | Familie | Beschreibung |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/de/grammar/value/time/duration-nanoseconds/) | TIME | Vorzeichenbehaftete Nanosekunden-Dauer ohne Epoche |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/de/grammar/value/binary/opaque-bytes/) | BINARY | Bytefolge unbekannter Bedeutung/unbekannten Formats. Gerade Bytezahl |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/de/grammar/value/binary/opaque-bytes/) | BINARY | Wie oben. Ungerade Bytezahl |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/de/grammar/value/binary/bit-vector/) | BINARY | N Bits, MSB-first gespeichert, nach einer Bit-Anzahl |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | BF16-Interchange-Bits mit festem Payload 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/de/grammar/value/vector/dense-i16-vector/) | NUMERIC | Zusammenhängender Big-Endian-int16-Vektor |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/de/grammar/value/vector/dense-u16-vector/) | NUMERIC | Zusammenhängender Big-Endian-uint16-Vektor |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/de/grammar/value/vector/dense-i32-vector/) | NUMERIC | Zusammenhängender Big-Endian-int32-Vektor |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/de/grammar/value/vector/dense-u32-vector/) | NUMERIC | Zusammenhängender Big-Endian-uint32-Vektor |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/de/grammar/value/vector/dense-i64-vector/) | NUMERIC | Zusammenhängender Big-Endian-int64-Vektor |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/de/grammar/value/vector/dense-u64-vector/) | NUMERIC | Zusammenhängender Big-Endian-uint64-Vektor |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/de/grammar/value/vector/dense-binary16-vector/) | NUMERIC | Zusammenhängender IEEE-754-binary16-Vektor |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/de/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | Zusammenhängender BF16-Vektor |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/de/grammar/value/vector/dense-binary32-vector/) | NUMERIC | Zusammenhängender IEEE-754-binary32-Vektor |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/de/grammar/value/vector/dense-binary64-vector/) | NUMERIC | Zusammenhängender IEEE-754-binary64-Vektor |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/de/grammar/value/vector/point2-binary64/) | NUMERIC | Zweidimensionaler IEEE-binary64-Vektor in der Reihenfolge `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/de/grammar/value/vector/point3-binary64/) | NUMERIC | Dreidimensionaler IEEE-binary64-Vektor in der Reihenfolge `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/de/grammar/value/vector/bbox2-binary64/) | NUMERIC | IEEE-binary64-Vektor in der Reihenfolge `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/de/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape und C-contiguous dichter Payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/de/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape und Payload, gepackt mit low-bit-first innerhalb eines Oktetts |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/de/grammar/value/etc/complex64/) | NUMERIC | Zwei binary32 in der Reihenfolge `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/de/grammar/value/etc/complex128/) | NUMERIC | Zwei binary64 in der Reihenfolge `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/de/grammar/value/etc/rational-i64/) | NUMERIC | Normalisierter int64-Numerator und positiver int64-Denominator |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/de/grammar/value/etc/closed-interval-binary64/) | NUMERIC | Abgeschlossenes binary64-Intervall mit `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/de/grammar/value/etc/quaternion-binary32/) | NUMERIC | Vier binary32 in der Reihenfolge `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/de/grammar/value/binary/blake3-256-digest/) | BINARY | Standard-BLAKE3-Ergebnis mit festem Payload 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/de/grammar/value/text/uri-relative-ref/) | TEXT | ASCII-Bytefolge einer relative-ref nach RFC 3986. Gerade Bytezahl |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/de/grammar/value/text/uri-relative-ref/) | TEXT | Wie oben. Ungerade Bytezahl |
| `0x0020` IETF | `0xC000` | [CRC32C](/de/grammar/value/binary/crc32c/) | BINARY | Castagnoli-CRC-32C-Ergebnis mit festem Payload 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/de/grammar/value/binary/ipv4-address/) | BINARY | 32-Bit-IPv4-Adresse mit festem Payload 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/de/grammar/value/binary/ipv6-address/) | BINARY | 128-Bit-IPv6-Adresse mit festem Payload 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/de/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE-754-decimal32-DPD mit festem Payload 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/de/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE-754-decimal64-DPD mit festem Payload 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/de/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE-754-decimal128-DPD mit festem Payload 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/de/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE-754-decimal32-BID mit festem Payload 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/de/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE-754-decimal64-BID mit festem Payload 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/de/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE-754-decimal128-BID mit festem Payload 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Vorzeichenbehaftete Nanosekundenzahl seit der Unix/POSIX-Epoche |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/de/grammar/value/binary/mac-48-address/) | BINARY | 48-Bit-IEEE-802-MAC-Adresse mit festem Payload 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/de/grammar/value/vector/rgba8-unorm/) | NUMERIC | Fester gepackter Vektor aus 4×UNORM8 in der Reihenfolge R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/de/grammar/value/vector/bgra8-unorm/) | NUMERIC | Fester gepackter Vektor aus 4×UNORM8 in der Reihenfolge B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | ONNX-E4M3FN-Skalar im oberen Oktett des Payloads |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | ONNX-E4M3FNUZ-Skalar im oberen Oktett des Payloads |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | ONNX-E5M2-Skalar im oberen Oktett des Payloads |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | ONNX-E5M2FNUZ-Skalar im oberen Oktett des Payloads |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Vorzeichenloser reiner Exponenten-Skalar E8M0FNU im oberen Oktett des Payloads |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | ONNX/DLPack-E2M1FN-Skalar im oberen Nibble des Payloads |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/de/grammar/value/time/tai-timestamp-seconds/) | TIME | Vorzeichenbehaftete SI-Sekundenzahl seit `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Vorzeichenbehaftete Nanosekundenzahl seit derselben TAI-Epoche |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/de/grammar/value/binary/sha-512-digest/) | BINARY | SHA-512-Ergebnis mit festem Payload 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/de/grammar/value/binary/sha3-256-digest/) | BINARY | SHA3-256-Ergebnis mit festem Payload 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/de/grammar/value/time/gps-timestamp-seconds/) | TIME | Vorzeichenbehaftete Sekundenzahl seit der GPS-Epoche |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/de/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Vorzeichenbehaftete Nanosekundenzahl seit der GPS-Epoche |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/de/grammar/meta/)

Die oberen 3 Bit des Codec bilden die Klasse. Meta hat keinen ISSUER-Code.

| Obere 3 Bit | Klasse | Direkter Code | Gegenstand |
|---|---|---|---|
| `000` | [Struktur](/de/grammar/meta/structure/) | `0x00`~`0x0F` | Grenzen und Länge des Dokuments |
| `001` | [Definition](/de/grammar/meta/declaration/) | `0x10`~`0x1F` | Interpretationsdeklarationen |
| `010` | [Herkunft](/de/grammar/meta/provenance/) | `0x20`~`0x2F` | Wer, wann, woher |
| `011` | [Abstammung](/de/grammar/meta/lineage/) | `0x30`~`0x3F` | Woraus und wie es entstanden ist |
| `100` | [Verifikation](/de/grammar/meta/verification/) | `0x40`~`0x4F` | Ob man ihm vertrauen kann |
| `101` | [Richtlinie](/de/grammar/meta/policy/) | `0x50`~`0x5F` | Wie damit umzugehen ist |
| `110` | [IMPORT](/de/grammar/meta/import/) | `0x60`~`0x6F` | Importiert ein externes Dokument über eine IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Struktur (`000`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x00` | [DOC-1WORD](/de/grammar/meta/structure/doc/) | Dokumentbeginn mit der Gesamtlänge in Payload 1 WORD |
| `0x01` | [DOC-2WORD](/de/grammar/meta/structure/doc/) | Dokumentbeginn mit der Gesamtlänge in Payload 2 WORD |
| `0x02` | [DOC-4WORD](/de/grammar/meta/structure/doc/) | Dokumentbeginn mit der Gesamtlänge in Payload 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/de/grammar/meta/structure/body/) | 1 WORD. Beendet den HEAD des Dokuments und beginnt den BODY. |
| `0x0F` | [END](/de/grammar/meta/structure/end/) | 1 WORD. Schließt das Dokument. |

### Definition (`001`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x10` | [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/) | Befolgte GEUL-Spezifikationsausgabe. Der Payload ist selbst eine vorzeichenlose Ganzzahl in der kürzesten Breite. v1 ist `0x0001` (Record `0x1890 0x0001`) |
| `0x11` | [PROFILE](/de/grammar/meta/declaration/profile/) | Angewandtes Profil |
| `0x12` | [DOC-ID](/de/grammar/meta/declaration/doc-id/) | Kennung dieses Dokuments. Eingebettetes Reference `DOC-POINTER` (Issuer, Dokument-ID, Version 0) |
| `0x13` | [EFFECTIVE-FROM](/de/grammar/meta/declaration/effective-from/) | Inkrafttreten dieser Version. Value GREGORIAN-DATE oder POSIX-TIMESTAMP. Fehlt er, gilt der Veröffentlichungszeitpunkt |
| `0x14` | [EFFECTIVE-UNTIL](/de/grammar/meta/declaration/effective-until/) | Ende der Gültigkeit dieser Version (befristetes Recht). Fehlt er, bis die nächste Version in Kraft tritt |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/de/grammar/meta/declaration/default-language/) | Standardsprache |
| `0x17`~`0x1F` | Reserved |  |

### Herkunft (`010`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x20` | [AUTHOR](/de/grammar/meta/provenance/author/) | Autor. Reference (git author) |
| `0x21` | [CO-AUTHOR](/de/grammar/meta/provenance/co-author/) | Mitautor. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/de/grammar/meta/provenance/created-at/) | Erstellungszeitpunkt. TIME-Value (git author date) |
| `0x23` | [MODIFIED-AT](/de/grammar/meta/provenance/modified-at/) | Änderungszeitpunkt. TIME-Value |
| `0x24` | [RECORDED-BY](/de/grammar/meta/provenance/recorded-by/) | Aufzeichnende Instanz. Reference (git committer) |
| `0x25` | [RECORDED-AT](/de/grammar/meta/provenance/recorded-at/) | Aufzeichnungszeitpunkt. TIME-Value (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- Quellmaterial samt Bereich, Beschaffungszeitpunkt und Hash schreibt man nicht als Meta, sondern als Beleg-Edge [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) (Target `0`) im HEAD und dessen QUALIFIER.

### Abstammung (`011`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x30` | [PARENT](/de/grammar/meta/lineage/parent/) | Inhaltshash der unmittelbar vorherigen Version (git parent). Fehlt er, ist es die erste Version; mehrere bedeuten einen Merge (git merge commit). |
| `0x31` | [DERIVED-FROM](/de/grammar/meta/lineage/derived-from/) | Abgeleitet von Records/Material einer anderen Abstammungslinie. Um eine bestimmte Version externen Materials festzulegen, hängt man an das [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) im HEAD einen QUALIFIER für den Originalhash (P4092) an (git submodule). |
| `0x32` | [GENERATED-BY](/de/grammar/meta/lineage/generated-by/) | Erzeugende Instanz. Mensch, Modell, Regelmaschine |
| `0x33` | [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/) | Transformationsmethode. Werkzeug, Regel, Version |
| `0x34` | [CHERRY-PICKED-FROM](/de/grammar/meta/lineage/cherry-picked-from/) | Inhaltshash der Ursprungsversion einer aus einer anderen Abstammungslinie übernommenen Änderung (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/de/grammar/meta/lineage/reverts/) | Inhaltshash der Version, deren Änderung zurückgenommen wird (git revert) |
| `0x36` | [REPLACES](/de/grammar/meta/lineage/replaces/) | Inhaltshash der überarbeiteten Version (git amend/rebase). Die ursprüngliche Version wird nicht gelöscht. |
| `0x37` | [SQUASHED-FROM](/de/grammar/meta/lineage/squashed-from/) | Inhaltshashes der zu einer zusammengefassten Ursprungsversionen (git squash) |
| `0x38` | [MESSAGE](/de/grammar/meta/lineage/message/) | Grund der Änderung. UTF8-LANGUAGE-TEXT-Value, einer je Sprache (git commit message) |
| `0x39` | [TAG](/de/grammar/meta/lineage/tag/) | Unveränderlicher Name einer Version. TEXT-Value und Inhaltshash (git annotated tag) |
| `0x3A` | [DELTA-BASE](/de/grammar/meta/lineage/delta-base/) | Diese Versionsdatei ist ein Diff gegen die Basisversion desselben Dokuments (2-WORD-Versions-ID) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/de/grammar/meta/lineage/delta-remove/) | Liste der LOCAL IDs (Edge Ids), die im Diff aus dem Basis-BODY zu entfernen sind |
| `0x3C` | [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/) | Nächste zu vergebende LOCAL ID (auto increment). Steht im HEAD der Versionsliste `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Verifikation (`100`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x40` | [ISSUER-KEY](/de/grammar/meta/verification/issuer-key/) | Deklaration von Signaturalgorithmus-ID und öffentlichem Schlüssel eines selbst ausgestellten Issuers |
| `0x41` | [SIGNATURE](/de/grammar/meta/verification/signature/) | Signatur über ein Ziel. Die Signatur über ein Dokument signiert den Inhaltshash (git signierter Commit/Tag) |
| `0x42` | [SIGNED-OFF](/de/grammar/meta/verification/signed-off/) | Bestätigung des Beitragsrechts. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/de/grammar/meta/verification/confidence/) | Vertrauenswert |
| `0x44` | [VERDICT](/de/grammar/meta/verification/verdict/) | Urteil über das gesamte Dokument. Pass, Review, Fail. Auf Ebene von Knoten/Records gilt [TOULMIN](/de/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Richtlinie (`101`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x50` | [LICENSE](/de/grammar/meta/policy/license/) | Lizenz. Reference |
| `0x51` | [ACCESS](/de/grammar/meta/policy/access/) | Zugriffsbereich |
| `0x52` | [PRIVACY](/de/grammar/meta/policy/privacy/) | Datenschutzstufe |
| `0x53` | [RETENTION](/de/grammar/meta/policy/retention/) | Aufbewahrungsfrist |
| `0x54` | [CONSENT](/de/grammar/meta/policy/consent/) | Umfang und Grundlage der Einwilligung |
| `0x55` | [USAGE](/de/grammar/meta/policy/usage/) | Nutzungsbeschränkung |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x60` | [IMPORT-DOC](/de/grammar/meta/import/import-doc/) | Importiert ein externes Dokument über eine IMPORT ID. Eingebettetes Reference `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
