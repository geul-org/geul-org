---
title: "Code-Index"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Diese Seite ist der Index aller Codecs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Diese Seite ist der Index aller Codecs. Ein Klick auf einen Namen führt zum Detaildokument des Codec. Direkte Codes, die nicht in den Tabellen stehen, sind Reserved.

## Kind {#kind}

Das TAG WORD lautet `000K KKKC CCCC LLLL`. Die oberen 4 Bit `KKKK` sind der Abschnitt, `C` ist der 5-Bit-Offset im Abschnitt, `LLLL` ist die Length. Die 9 Bit aus Abschnitt und `C` bilden den Codec-Platz. Die TAG ID wird als `0x000L` geschrieben. Die ersten drei Ziffern sind diese 9 Bit (`w >> 4`), `L` ist die Length-Stelle ([Record und TAG WORD](record.md)).

| Abschnitt | TAG ID | Kategorie | Beschreibung |
|---|---|---|---|
| 0–2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | Records, die auf Gegenstände verweisen |
| 3, 4 | `0x060L~0x09FL` | [Value](value/_index.md) | Wert-Records |
| 5–13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | verbindende Records |
| 14, 15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | Records über Dokumente und Records |

- Der Abschnitt ist `S = w >> 9` (4 Bit), und ein Abschnitt hat 32 Plätze.
- Das Kind wird allein am Abschnittsbereich bestimmt: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, der Rest Meta. Es gibt keine Ausnahmen.
- Die letzten drei Plätze der Bereiche Reference, Value und Edge sind ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta hat kein ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Name | Kategorie | Ziel-ID |
|---|---|---|---|
| `0x000L~0x002L` | [Slot-Marker](slot-marker.md) | Slot-Marker | Gruppe von 1-WORD-Markern, die auf keinen Gegenstand verweisen (Tabelle unten) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | Deklaration | von diesem Dokument vergebene ID |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | Deklaration | von geul.org unter CC0 vergebene Entität. Kleine Nummern werden häufig genutzten Entitäten zugewiesen |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | Deklaration | GEUL SIDX (Semantic-aligned Index). Bezeichner, dessen Bits Bedeutung tragen |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | Deklaration | Wikidata-Eintrag. Die ganze Zahl nach `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | Deklaration | Wikidata-Eigenschaft. Die ganze Zahl nach `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | Verweis | LOCAL-ID eines mit `IMPORT-DOC` importierten Dokuments. IMPORT-ID 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | Verweis | wie oben. IMPORT-ID 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | Verweis | wie oben. IMPORT-ID 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | Verweis und Deklaration | LOCAL-ID eines Dokuments eines 2-WORD-Issuers |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | Verweis und Deklaration | LOCAL-ID eines Dokuments eines 4-WORD-Issuers |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | Verweis und Deklaration | LOCAL-ID eines Dokuments eines 16-WORD-Issuers |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | Verweis und Deklaration | der Issuer selbst. Der Payload ist nur der Issuer (2/4/16 WORD), es gibt keine Ziel-ID |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | Verweis und Deklaration | eine Version eines Issuer-Dokuments. Issuer + Dokument-ID 4 WORD + Versions-ID 2 WORD, keine Ziel-ID |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | Verweis und Deklaration | eine Version eines Issuer-Codec. Issuer + Codec-ID 2 WORD + Versions-ID 2 WORD, keine Ziel-ID |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | Deklaration | ein Eintrag des GEUL-Token-Vokabulars (Token-ID 0~65.535). Payload 1 WORD, insgesamt 2 WORD |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | Deklaration | wie oben. Token-ID 65.536~131.071 (65.536 + Payload) |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Issuer-Format | Issuer 2 WORD und Codec-Nummer 2 WORD. Kategorie und Ziel legt das Issuer-Dokument fest |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Issuer-Format | Issuer 4 WORD und Codec-Nummer 2 WORD. Sonst wie oben |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Issuer-Format | Issuer 16 WORD und Codec-Nummer 2 WORD. Sonst wie oben |

- Reference umfasst drei Abschnitte. Abschnitt 0 Entitäten `0x000L~0x01FL` (Slot-Marker, 5Q-System), Abschnitt 1 EXTERNAL `0x020L~0x03FL`, Abschnitt 2 Sonstiges `0x040L~0x05FL` (Pointer, REFERENCE-ISSUER). Reserved sind `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL` und `0x045L~0x05CL`.
- Die 5er-Gruppen (von LOCAL bis EXTERNAL-ISSUER-16WORD) belegen je einen Platz in der Quantifier-Reihenfolge unten. Beispiel: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Slot-Marker (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Slot-Marker](slot-marker.md). Sie stehen nur dann an einer Stelle, wenn die CODEC-Liste des Feldes genau dieses WORD aufführt.

| WORD | Name | Bedeutung | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | nicht angegeben. Ein optionales Feld wurde weggelassen. Es wird nichts über die Welt behauptet | kein Snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | unbekannt. Ein Wert existiert, aber man weiß nicht, welcher | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | nicht vorhanden. Es gibt keinen Wert | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Name | Bedeutung | Beispiel |
|---|---|---|---|
| `0` | Identified | identifizierter Gegenstand | Elon Musk, Südkorea |
| `1` | Generic | allgemeine, definierende Aussage über eine ganze Art. Ausnahmen sind zulässig. | Soldaten gehorchen Befehlen |
| `2` | Free-choice | beliebiger Gegenstand, der die Bedingung erfüllt | irgendein Soldat |
| `3` | Universal | alle Gegenstände im gegebenen Bereich | alle Soldaten |
| `4` | Variable | Diskursvariable | diese Person, diese Frau |

- Die Quantifizierung liest man am Offset `C` im Abschnitt. In Abschnitt 0 ist bei `5 <= C < 30` die Quantifizierung `C % 5` und das System `C / 5` (1–5). In Abschnitt 1 ist bei `C < 30` die Quantifizierung `C % 5` und das System `6 + C / 5` (6–11). Für Marker (Abschnitt 0, `C < 3`) und Abschnitt 2 (Pointer, REFERENCE-ISSUER) gilt das nicht.
- ISSUER-POINTER, DOC-POINTER und CODEC-POINTER sind je ein Platz ohne Quantifizierung. Die Quantifizierung von REFERENCE-ISSUER legt das vom Issuer herausgegebene Codec-Dokument fest.

## Issuer {#issuer}

Ein Issuer ist der Akteur, der Dokumente und Formate definiert — [Issuer und Veröffentlichung](issuer.md)

| Stelle | Bedeutung |
|---|---|
| ISSUER-Codes von Reference, Value und Edge (die letzten drei Plätze jedes Bereichs) | das von diesem Issuer definierte Format |
| Meta `DOC-ID` | der Issuer, der dieses Dokument herausgegeben hat |
| Meta `IMPORT-DOC` | der Issuer, der das importierte Dokument herausgegeben hat |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | der Issuer des Dokuments oder Codec, auf das verwiesen wird (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | der Issuer selbst, auf den verwiesen wird (2/4/16 WORD) |

| Issuer-Breite | Vergabe |
|---|---|
| 2 WORD | Registrierung bei geul.org. Issuer mit Nachweis des Domainbesitzes (z. B. company.com). Auch die Nummern, die geul.org an Normungsorganisationen und wichtige Institutionen vergibt, haben diese Breite ([2-WORD-Zuweisungstabelle](issuer.md#2-word-배정표)). |
| 4 WORD | Registrierung bei geul.org. Issuer, die ohne Besitznachweis registriert wurden |
| 16 WORD | selbst ausgestellt. Wird ohne Registrierung aus dem öffentlichen Schlüssel berechnet. Es gelten die Erzeugungsregeln unten. |

### Signaturalgorithmus des 16-WORD-Issuers {#16-word-issuer-서명-알고리즘}

| Signaturalgorithmus-ID | Algorithmus |
|---|---|
| `0x0001` | Ed25519 |
| sonst | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

Die Familie eines direkten Codes ist `(Code − 0xA0) >> 5` (der Code sind die ersten drei Ziffern der TAG ID). Familien umfassen je 32 Plätze und entsprechen dem Abschnitt `w >> 9` minus 5. Zugewiesen sind die folgenden fünf Familien direkter Codes. `0x135L~0x1BCL` ist Reserved (die Abschnitte 10–12 sind vollständig Reserved). Für das Issuer-Format gibt es keine Familienregel.

| Abschnitt | Familie | Direkte Codes |
|---|---|---|
| 5 | Aussage | `0x0A0L~0x0BFL` |
| 6 | Beleg | `0x0C0L~0x0DFL` |
| 7 | Ausführung | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | [TOULMIN](toulmin/_index.md)-Format | `0x120L~0x134L` |

- `0x11CL~0x11FL` ist Reserved.
- `0x1BDL~0x1BFL` (die letzten drei Plätze von Abschnitt 13) ist EDGE-ISSUER (siehe Edge-ISSUER-Format unten).

### Aussage (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Name | Unterformat | Beschreibung |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | gerichtete Bindung, bei der ein Subject, das eine Reference ist, auf ein Object verweist |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | Identität: zwei Reference verweisen auf denselben Gegenstand |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | Nichtidentität: zwei Reference verweisen auf verschiedene Gegenstände |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | bindet an das Subject einen Namen (`UTF8-TEXT-*`), den die Maschine abgleicht. Er ist im Bereich eindeutig, muss exakt übereinstimmen und hat keine Sprache |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | verbindet das Subject mit seinem Namen (Label) in einer Sprache. Das Object ist UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | verbindet das Subject mit einem anderen Namen (Alias). Das Layout ist wie bei LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | verbindet das Subject mit seiner Beschreibung (Description) in einer Sprache. Das Layout ist wie bei LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | verkürzte Verbaussage |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | Verbaussage |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | Proposition in der Reihenfolge Predicate, Subject, Object und Rank. Das Object ist ein Wert oder ein Marker UNKNOWN-VALUE oder NO-VALUE. Die Bedeutung ist die Gesamtheit aller QUALIFIER, die auf diese Edge Id verweisen |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | eine Bedingung, die die Proposition einer anderen Edge einschränkt. Property, Target (Edge Id), Value (Wert oder Marker UNKNOWN-VALUE oder NO-VALUE). Sie ist Teil der Proposition |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | ja | Struktur zur Darstellung von Weltbildern |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | ja | Struktur zur Darstellung der Ordnung von Welten und Ereignissen |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | ja | Szenenstruktur zur Beschreibung von Szenarioeigenschaften |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | Veröffentlichung eines Dokuments. DOC-POINTER, Inhaltshash |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | Deprecation einer veröffentlichten Version. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | Löschung (Grabstein) einer veröffentlichten Version. DOC-POINTER, Grundkategorie |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Deklaration des Payload-Aufbaus eines Codec. Ziel-Kind und -Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | ein Payload-Feld. Zugehöriges DECLARE, Breite: Record (Length des TAG) oder Rohwert n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | ein Codewert eines Rohwert-Feldes. Feld, Codewert |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | ein Kind und Codec, den das Feld annimmt. Feld, Ziel-WORD (`000K KKKC CCCC LLLL`, LLLL 0000 exakt, 1111 Wildcard (alle 32 Plätze des Abschnitts), Slot-Marker nur als exaktes Ziel `0000`, `0010`, `0020`). Ein Record-Feld hat mehrere (geschlossene Liste), ein Rohwert-Feld eines (dieses Value ohne TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Gruppe |
|---|---|
| `0x0A0L~0x0A7L` | Verweis und Name |
| `0x0A8L~0x0AFL` | Proposition |
| `0x0B0L~0x0B7L` | Struktur |
| `0x0B8L~0x0BFL` | Sonstiges |

### Beleg (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Name | Unterformat | Beschreibung |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | verbindet einen Record oder das ganze Dokument mit seinem Ursprung. Target (BODY-Edge-Id, im HEAD `0` = ganzes Dokument), Origin (Reference, ABSENT oder UNKNOWN-VALUE). Die Eigenschaft des Ursprungs steht in einem TRIPLE mit dem Ursprung als Subject, die Eigenschaft des Zitats (Abrufdatum, Fundstelle, Hash des Originaltexts) in QUALIFIER am SOURCE. SOURCE für das ganze Dokument und dessen QUALIFIER stehen im HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- Umfang des Originaltexts, Urheber, Zuverlässigkeit, Geltungsdauer je Vorschrift und alte Records schreibt man mit QUALIFIER, und die Version, in der etwas zuerst auftrat, wird aus dem Versionsverlauf berechnet ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Ausführung (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | Funktionsdeklaration. Symbol, Liste der Parametersymbole, Rückgabetyp, Rumpf (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | Typdeklaration. Symbol und Aufbau (Liste der Feldsymbole, Aufzählungswerte, Aliasziel) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | konstanter Ausdruck. Ein eingebettetes Value |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | unärer Ausdruck. Operator 1 WORD, Operand |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | binärer Ausdruck. Operator 1 WORD, links, rechts |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | Aufruf. Zielfunktion, Anzahl der Argumente, Argument × Anzahl der Argumente |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | Memberzugriff. Ziel, Feldsymbol |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | Indexzugriff. Ziel, Index |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | Erzeugung zusammengesetzter Werte (Liste, Record). Typ, Anzahl der Elemente, Element × Anzahl der Elemente |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | bedingter Ausdruck. Bedingung, Wert bei wahr, Wert bei falsch |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | geordnete Folge von Anweisungen. Anzahl der Anweisungen, Anweisung × Anzahl der Anweisungen |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | Zuweisung. Ziel (Symbol, MEMBER, INDEX), Wert |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | bedingte Verzweigung. Bedingung, BLOCK bei wahr, bei falsch (BLOCK oder IF, 0 wenn keiner) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | Mehrfachverzweigung. Ziel, Anzahl der Zweige, (Wert, BLOCK) × Anzahl der Zweige, Standard-BLOCK (0 wenn keiner) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | bedingte Schleife. Bedingung, Rumpf-BLOCK |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | Iterationsschleife. Elementsymbol, Ziel, Rumpf-BLOCK |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | Schleifensteuerung. Art 1 WORD (break, continue), Zielschleife |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | Rückgabe. Wert (0 wenn keiner) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | Fehler auslösen. Fehlerwert |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | Fehlerbehandlung. Rumpf-BLOCK, Fehlersymbol, Behandlungs-BLOCK, abschließender BLOCK (0 wenn keiner) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Gruppe |
|---|---|
| `0x0E0L~0x0E7L` | Deklaration |
| `0x0E8L~0x0EFL` | Ausdruck |
| `0x0F0L~0x0F7L` | Anweisung |
| `0x0F8L~0x0FFL` | Fehler |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

Ausführlich: [TOULMIN](toulmin/_index.md)

| Codec | Name | Beschreibung |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | Falldeklaration. Beurteilungsgraph, der Knoten und Relationen enthält |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | Prädikatdeklaration. Beurteilungsfunktion oder -ausdruck, Beurteilungskriterium (Spec), Faktenvertrag (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | Deklaration eines Beurteilungskriteriums. Konstanten und Listen (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | Deklaration einer Behauptung. Setzt im Fall ein Prädikat als allgemeine Regel (Warrant). Kann angegriffen werden. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | Deklaration einer Gegenbehauptung. Greift mit eigener Schlussfolgerung an. Das Standard-Level ist Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | Deklaration einer Ausnahme. Greift ohne eigene Schlussfolgerung an. Das Standard-Level ist Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | Angriffsrelation. Die Beurteilung des Angreifers mindert die Beurteilung des Ziels schrittweise. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | Ausschlussrelation. Ist der Angreifer Active, nimmt er das Ziel endgültig aus der Aggregation. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | Prioritätskette `A > B > C`. Kurzform paarweiser SUPERSEDES. Layout offen |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | Aktion, die ausgeführt wird, wenn der Knoten Active ist |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | Aktion, die auch bei Wiederholungsversuchen nur einmal ausgeführt wird |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | Kompensationsaktion zu DO (Saga). Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | Verbindung, die nur beurteilt, ohne Nebenwirkung |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | externer Einstiegspunkt. Führt einen Fall aus oder beurteilt ihn |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | Einstiegspunkt für Ereignisse oder Zeitpläne ohne externen Aufruf |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | Beurteilungsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Beurteilungswert, Activated, Excluded, Level. Layout offen. Die Beurteilung des ganzen Dokuments ist Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | Nachweis der Beurteilung. Fundstelle, erwarteter Wert, tatsächlicher Wert (Fact). Layout offen |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Gruppe |
|---|---|
| `0x100L~0x107L` | Deklaration |
| `0x108L~0x10FL` | Relation |
| `0x110L~0x117L` | Ausführung |
| `0x118L~0x11FL` | Ergebnis (`0x11CL~0x11FL` sind Reserved) |

### TOULMIN-Format (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

Originaltext, Gliederung sowie Hilfsknoten und -relationen eines [TOULMIN](toulmin/_index.md)-Dokuments.

| Codec | Name | Beschreibung |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | Originaltext des Autors. SPAN-Breite und UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | Name oder Zeichenkette |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | Beginn eines Abschnitts. Abschnittscode |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | Beginn eines Fallbereichs |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | Ende eines Fallbereichs |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | Absatz in Prosa (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. Funktionsverweis |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. geordnete Ausführungsgruppe |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. Fall → Feld |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. Definitionseintrag → Wert oder Typ |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. Definitionseintrag → Feld |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. Einstiegspunkt → Fall, Ausführung |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. Einstiegspunkt → Fall, Beurteilung |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. Trigger → Fall |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. Trigger → Fall (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. Knoten → globaler Bezeichner |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. Alias → Pfad (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. Knoten → TEXT, Namensschreibweise |

- `0x135L~0x1BCL` ist Reserved.

### Edge-ISSUER-Format {#edge-issuer-형식}

Nach `0x1BDL`–`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)) stehen im Erweiterungs-TAG des Codec der Issuer und die Codec-Nummer, 2 WORD. Derzeit ist kein Edge-ISSUER-Format eingetragen.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Die Value-Nummer bedeutet keine Familie. Die direkten Codes liegen ohne Reserved in `0x060L~0x081L`. `0x082L~0x09CL` ist Reserved, und `0x09DL~0x09FL` ist VALUE-ISSUER. Die Familiennamen (NUMERIC, DECIMAL, TIME, TEXT, BINARY) sind thematische Gruppen. Paare aus gerader und ungerader Byteanzahl beginnen beim geraden Code.

| Familie | Direkte Codes |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Direkte Codes {#직접-코드}

| Codec | Name | Familie | Beschreibung |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false oder true in festen 1 WORD |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | vorzeichenbehaftete Ganzzahl im Zweierkomplement mit minimaler WORD-Zahl |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | Ganzzahl als Big-Endian-Unsigned-Magnitude mit minimaler WORD-Zahl |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | IEEE-754-binary16/32/64/128-Skalar mit Payload 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | Breite und Länge auf der Erde (WGS 84) als binary64, Unschärfe als binary32 und deren Einheiten-Reference (ABSENT = unbekannt) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Himmelskörper-Reference sowie Breite und Länge als binary64, Unschärfe als binary32 und deren Einheiten-Reference |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | numerischer Value amount (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheiten-Reference, untere und obere Schranke. Einheit und Schranken sind weglassbar (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | Bruch, der die Schreibweise des Originals bewahrt: Zähler als Ganzzahl oder Dezimalzahl, Nenner als vorzeichenlose Ganzzahl oder Dezimalzahl. Wird nicht gekürzt |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` aus vorzeichenbehaftetem Exponenten `E` und Koeffizient `C` im Zweierkomplement mit minimaler WORD-Zahl |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` aus vorzeichenbehaftetem Exponenten `E` und vorzeichenlosem Koeffizienten `C` mit minimaler WORD-Zahl |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | vorzeichenbehaftete Tageszahl, bezogen auf den proleptischen gregorianischen `1970-01-01` |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | vorzeichenloser Nanosekundenzähler seit Mitternacht des bürgerlichen Tages |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | vorzeichenbehafteter Sekundenzähler seit der Unix/POSIX-Epoche |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | vorzeichenbehaftete verstrichene Zeit in SI-Sekunden ohne Epoche |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | EDTF-Datumszeichenkette (ISO 8601-2). Gerade und ungerade Byteanzahl. Ein Datum, das sich als GREGORIAN-DATE schreiben lässt, wird nicht so geschrieben |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | GEDCOM-7-Datumswert als Zeichenkette. Bewahrt die Originalschreibweise anderer Kalender (julianisch usw.). Gerade und ungerade Byteanzahl |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | gültige UTF-8-Bytefolge ohne implizierte Normalisierung. Gerade Byteanzahl |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | wie oben. Ungerade Byteanzahl |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | ASCII-Bytefolge nach der `URI`-Produktion von RFC 3986. Gerade Byteanzahl |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | wie oben. Ungerade Byteanzahl |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | ASCII-Bytefolge eines vollständigen BCP-47-Language-Tags in kanonischer Schreibung. Gerade Byteanzahl |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | wie oben. Ungerade Byteanzahl |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | Text mit Sprachangabe. Sprach-Value-Record (LANGUAGE-SHORT-CODE oder LANGUAGE-BCP47-CODE) und UTF-8-Bytes. Gerade oder ungerade Anzahl der Textbytes |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | BCP-47-Tag, geschrieben als Nummer des GEUL Language Registry (Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | RFC-9562-UUID mit 128 Bit, fester Payload 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | SHA-256-Ergebnis, fester Payload 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | SHA-1-Ergebnis, fester Payload 10 WORD. Nur zur Identifikation wie bei git-Objekt-IDs |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | Bytefolge mit unbekannter Bedeutung und Form. Gerade Byteanzahl |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | wie oben. Ungerade Byteanzahl |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N Bit, MSB-first gespeichert nach der Bit-Anzahl |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | vorzeichenbehaftete verstrichene Zeit in Nanosekunden ohne Epoche |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | vom Issuer definiertes Format. Siehe Value-ISSUER-Format unten |

### Value-ISSUER-Format {#value-issuer-형식}

Nach `0x09DL`–`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)) stehen im Erweiterungs-TAG des Codec der Issuer und die Codec-Nummer, 2 WORD. Das Codec-Dokument liegt unter `codecs/` dieses Issuers, benannt nach der Codec-Nummer des Records. Beispiel: IETF CRC32C liegt unter `0x00000007/codecs/0x0000C000/` ([Veröffentlichungsadresse und Versionsliste](publishing.md)).

| Issuer | Codec-Nummer | Name | Beschreibung |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | BF16-Interchange-Bits, fester Payload 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | zusammenhängender Big-Endian-int16-Vektor |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | zusammenhängender Big-Endian-uint16-Vektor |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | zusammenhängender Big-Endian-int32-Vektor |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | zusammenhängender Big-Endian-uint32-Vektor |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | zusammenhängender Big-Endian-int64-Vektor |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | zusammenhängender Big-Endian-uint64-Vektor |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | zusammenhängender IEEE-754-binary16-Vektor |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | zusammenhängender BF16-Vektor |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | zusammenhängender IEEE-754-binary32-Vektor |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | zusammenhängender IEEE-754-binary64-Vektor |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | zweidimensionaler IEEE-binary64-Vektor in der Reihenfolge `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | dreidimensionaler IEEE-binary64-Vektor in der Reihenfolge `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | IEEE-binary64-Vektor in der Reihenfolge `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape und C-zusammenhängender Dense-Payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape und Packed-Payload mit Low-Bit-First innerhalb des Oktetts |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | zwei binary32 in der Reihenfolge `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | zwei binary64 in der Reihenfolge `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | normalisierter int64-Zähler und positiver int64-Nenner |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | binary64-Intervall, abgeschlossen, mit `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | vier binary32 in der Reihenfolge `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | Standard-BLAKE3-Ergebnis, fester Payload 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | ASCII-Bytefolge einer relative-ref nach RFC 3986. Gerade Byteanzahl |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | wie oben. Ungerade Byteanzahl |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | Castagnoli-CRC-32C-Ergebnis, fester Payload 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | 32-Bit-IPv4-Adresse, fester Payload 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | 128-Bit-IPv6-Adresse, fester Payload 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE-754-decimal32-DPD, fester Payload 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE-754-decimal64-DPD, fester Payload 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE-754-decimal128-DPD, fester Payload 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE-754-decimal32-BID, fester Payload 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE-754-decimal64-BID, fester Payload 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE-754-decimal128-BID, fester Payload 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | vorzeichenbehafteter Nanosekundenzähler seit der Unix/POSIX-Epoche |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | 48-Bit-IEEE-802-MAC-Adresse, fester Payload 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | fester gepackter Vektor aus 4×UNORM8 in der Reihenfolge R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | fester gepackter Vektor aus 4×UNORM8 in der Reihenfolge B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | ONNX-E4M3FN-Skalar im oberen Oktett des Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | ONNX-E4M3FNUZ-Skalar im oberen Oktett des Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | ONNX-E5M2-Skalar im oberen Oktett des Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | ONNX-E5M2FNUZ-Skalar im oberen Oktett des Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | vorzeichenloser reiner Exponenten-Skalar E8M0FNU im oberen Oktett des Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | ONNX/DLPack-E2M1FN-Skalar im oberen Nibble des Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | vorzeichenbehafteter SI-Sekundenzähler seit `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | vorzeichenbehafteter Nanosekundenzähler seit derselben TAI-Epoche |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | SHA-512-Ergebnis, fester Payload 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | SHA3-256-Ergebnis, fester Payload 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | vorzeichenbehafteter Sekundenzähler seit der GPS-Epoche |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | vorzeichenbehafteter Nanosekundenzähler seit der GPS-Epoche |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Die Meta-Nummer zeigt die Klasse nicht an den Bits. Die Klasse erkennt man an der Bereichstabelle unten. Die Verifikationsklasse sind Records mit `C >= 5` in Abschnitt 15, also `w >= 0x1E50`, und lässt sich ohne Codebook erkennen. Meta hat keine ISSUER-Codes.

| Klasse | Direkte Codes | Gegenstand |
|---|---|---|
| [Struktur](meta/_index.md#구조) | `0x1C0L~0x1C4L` | Grenzen und Länge des Dokuments |
| [Definition](meta/_index.md#정의) | `0x1C5L~0x1CAL` | Deklarationen zur Deutung |
| [Herkunft](meta/_index.md#출처) | `0x1CBL~0x1D0L` | wer, wann, wo |
| [Abstammung](meta/_index.md#계보) | `0x1D1L~0x1DDL` | woraus und wie es entstand |
| [Richtlinie](meta/_index.md#정책) | `0x1DEL~0x1E3L` | wie damit umzugehen ist |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | holt ein externes Dokument über eine IMPORT-ID herein (`IMPORT-DOC`) |
| [Verifikation](meta/_index.md#검증) | `0x1E5L~0x1E9L` | ob es vertrauenswürdig ist |
| Reserved (nur Verifikation) | `0x1EAL~0x1FFL` |  |

- Die Nummern reichen ab `0x1C0L` ohne Reserved durch. Ein neues Meta außerhalb der Verifikation lässt sich nicht vor der Verifikation einfügen. Das hintere Reserved `0x1EAL~0x1FFL` ist der Verifikation vorbehalten. Legt man hier ein Meta außerhalb der Verifikation ab, fällt es aus dem Inhaltshash heraus.

### Struktur (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | Dokumentbeginn, dessen Gesamtlänge im Payload (1 WORD) steht |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | Dokumentbeginn, dessen Gesamtlänge im Payload (2 WORD) steht |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | Dokumentbeginn, dessen Gesamtlänge im Payload (4 WORD) steht |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Beendet den HEAD des Dokuments und beginnt den BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Schließt das Dokument. |

### Definition (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Fassung der GEUL-Spezifikation, der das Dokument folgt. Der Payload ist selbst die vorzeichenlose Ganzzahl in kürzester Breite. v1 ist `0x0001` (Record `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | angewandtes Profil |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | Bezeichner dieses Dokuments. Eingebettete Reference `DOC-POINTER` (Issuer, Dokument-ID, Version 0). Ein Codec-Dokument verwendet `CODEC-POINTER` (Issuer, Codec-ID, Version 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | Datum des Inkrafttretens dieser Version. GREGORIAN-DATE oder POSIX-TIMESTAMP Value. Fehlt es, gilt der Veröffentlichungszeitpunkt |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | Ende der Geltungsdauer dieser Version (befristetes Gesetz). Fehlt es, gilt sie, bis die nächste Version in Kraft tritt |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | Standardsprache |

### Herkunft (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | Autor. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | Mitautor. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | Erstellungszeitpunkt. TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | Änderungszeitpunkt. TIME Value |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | aufzeichnender Akteur. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | Zeitpunkt der Aufzeichnung. TIME Value (git commit date) |

- Quellmaterial sowie dessen Umfang, Beschaffungszeitpunkt und Hash schreibt man nicht als Meta, sondern mit dem Beleg-Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) im HEAD (Target `0`) und dessen QUALIFIER.

### Abstammung (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | Inhaltshash der unmittelbar vorherigen Version (git parent). Fehlt er, ist es die erste Version; sind es mehrere, ist es ein Merge (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | abgeleitet von Records oder Material einer anderen Abstammungslinie. Um sich auf eine bestimmte Version externen Materials festzulegen, hängt man an das [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) im HEAD ein QUALIFIER mit dem Hash des Originaltexts (P4092) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | erzeugender Akteur. Mensch, Modell, Regelmaschine |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | Umwandlungsmethode. Werkzeug, Regeln, Version |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | Inhaltshash der Ursprungsversion, aus der eine Änderung einer anderen Linie übernommen wurde (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | Inhaltshash der Zielversion, deren Änderung zurückgenommen wurde (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | Inhaltshash der Zielversion, die umgeschrieben wurde (git amend, rebase). Die Ursprungsversion wird nicht gelöscht. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | Inhaltshashes der Ursprungsversionen, die zu einer zusammengefasst wurden (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | Grund der Änderung. UTF8-LANGUAGE-TEXT Value, einer je Sprache (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | unveränderlicher Name einer Version. TEXT Value und Inhaltshash (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | Diese Versionsdatei ist ein Diff gegen die Basisversion (Versions-ID 2 WORD) desselben Dokuments (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | Liste der LOCAL-IDs (Edge Id), die im Diff aus dem Basis-BODY zu entfernen sind |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | nächste zu vergebende LOCAL-ID (auto increment). Steht im HEAD der Versionsliste `versions.geul` |

### Richtlinie (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | Lizenz. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | Zugriffsbereich |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | Datenschutzstufe |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | Aufbewahrungsfrist |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | Umfang und Grundlage der Einwilligung |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | Nutzungsbeschränkung |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | holt ein externes Dokument über eine IMPORT-ID herein. Eingebettete Reference `DOC-POINTER` (bei einem Codec-Dokument `CODEC-POINTER`) + IMPORT-ID |

### Verifikation (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Name | Beschreibung |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | Deklaration von Signaturalgorithmus-ID und öffentlichem Schlüssel eines selbst ausgestellten Issuers |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | Signatur über ein Ziel. Die Signatur über ein Dokument signiert den Inhaltshash (git signierte Commits und Tags) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | Bestätigung des Beitragsrechts. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | Verlässlichkeit |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | Beurteilungsergebnis des ganzen Dokuments. Pass, Review, Fail. Auf Ebene von Knoten und Records gilt [TOULMIN](toulmin/_index.md) `VERDICT` (Edge `0x118L`) |

## Gesamte Zuweisungstabelle {#전체-배정표}

227 zugewiesene Plätze, 176 md. Das 5Q-System und die Paare gerader und ungerader Byteanzahl haben je Mitglied eine Zeile, und die md ist die md des Gruppenkopfes.

| TAG ID | Codec-ID | Name | Kind | Abschnitt | md | Gruppe |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Paar `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Paar `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | Gerade/Ungerade `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | Gerade/Ungerade `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | Gerade/Ungerade `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | Gerade/Ungerade `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | Gerade/Ungerade `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | Gerade/Ungerade `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | Gerade/Ungerade `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | Gerade/Ungerade `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | Gerade/Ungerade `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | Gerade/Ungerade `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | Gerade/Ungerade `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | Gerade/Ungerade `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | Gerade/Ungerade `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | Gerade/Ungerade `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
