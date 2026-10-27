---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Ein Edge ist ein Record, der Reference, Value und andere Edges zu einer Aussage verbindet. Die erste Komponente ist stets die Edge Id, und die oberen 2 Bit des Codec bilden die Familie (Beschreibung, Beleg, Ausführung, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Edge ist ein Record, der andere Records als Komponenten zu einer Aussage verbindet. Eine Aussage wie „Q42 ist ein Mensch“ oder „Der englische Name von Q42 ist Douglas Adams“ ist ein Edge.

## Layout

```
TAG WORD          0001 0LLL LCCC CCCC
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]  bei Issuer-Formaten
Edge Id           LOCAL-Reference-Record
Komponenten       in der vom Codec festgelegten Reihenfolge
```

- `LLLL` ist die Gesamtzahl der WORD einschließlich TAG WORD minus 1. Auch ohne Kenntnis des Codec springt der Decoder allein mit der Length zum nächsten Record.
- **Die erste Komponente ist stets die Edge Id (LOCAL Reference).** Da es ein LOCAL Reference ist (`0088` + ID, Quantifier `000`), kann man die Edge Id auch ohne Kenntnis des Codecs lesen.
- Jede Komponente findet ihre Grenze über ihre eigene Length. Die Position nach dem Lesen der letzten Komponente muss genau mit dem Ende des Edge übereinstimmen.
- Den Aufbau (Payload) der Komponenten legt das jeweilige Edge-Codec-Dokument fest.
- Bei Codecs mit Unterformaten (WORLD, TIMELINE, SCENE) bestimmt 1 WORD Codec-spezifischer TAG das Unterformat.
- Die Reihenfolge zwischen Edge-Records hat keine Bedeutung (außer wenn ein Codec sie eigens festlegt, z. B. in [TOULMIN](/de/grammar/edge/toulmin/)-Dokumenten).
- Auf andere Edges verweist man über die Edge Id. Auf Edges dieses Dokuments mit LOCAL, auf Edges anderer Dokumente mit einem Zeiger-Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familien

| Obere 2 Bit | Familie | Direkter Code | Aufgabe |
|---|---|---|---|
| `00` | Beschreibung | `0x00`~`0x1F` | Baut Inhalte über Welt und Ereignisse auf |
| `01` | Beleg | `0x20`~`0x3F` | Woher Records und Dokumente stammen ([SOURCE](/de/grammar/edge/source/)) |
| `10` | Ausführung | `0x40`~`0x5F` | Ausführbare Programmstruktur (AST) |
| `11` | [TOULMIN](/de/grammar/edge/toulmin/) | `0x60`~`0x7B` | Argumentationsgraph: Behauptung, Gegenbehauptung, Ausnahme, Angriffsbeziehung, Ausführung, Urteilsergebnis |

## Beschreibungs-Edges

| Codec | Name | Komponenten |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/de/grammar/edge/reference-node/) | Gerichtete Bindung, in der das Subject (Reference) auf das Object verweist |
| `0x01` | [SAME-NODE](/de/grammar/edge/same-node/) | Zwei Reference verweisen auf dasselbe Objekt |
| `0x02` | [DIFFERENT-NODE](/de/grammar/edge/different-node/) | Zwei Reference verweisen auf verschiedene Objekte |
| `0x03` | [BIND](/de/grammar/edge/bind/) | Bindet einen maschinengerechten Namen (UTF8-TEXT) an das Subject |
| `0x04` | [LABEL](/de/grammar/edge/label/) | Sprachname des Subject (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/de/grammar/edge/alias/) | Weiterer Name des Subject. Das Layout ist wie bei LABEL |
| `0x06` | [DESCRIPTION](/de/grammar/edge/description/) | Sprachbeschreibung des Subject. Das Layout ist wie bei LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Verbaussage |
| `0x0A` | [TRIPLE](/de/grammar/edge/triple/) | Eine Proposition (Predicate, Subject, Object) und rank |
| `0x0B` | [QUALIFIER](/de/grammar/edge/qualifier/) | Eine Bedingung, die die Proposition eines anderen Edge einschränkt |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Weltmodell, Ereignisreihenfolge, Szenenstruktur |
| `0x18`~`0x1A` | [PUBLICATION](/de/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Veröffentlichung, Einstellungsempfehlung und Löschung von Dokumentversionen ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#versionsliste)) |
| `0x1B`~`0x1E` | [DECLARE](/de/grammar/edge/declare/) / [FIELD](/de/grammar/edge/field/) / [ENUM](/de/grammar/edge/enum/) / [CODEC](/de/grammar/edge/codec/) | Vokabular zum Schreiben von Codec-Spezifikationen ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)) |

- `-SHORT` und die reguläre Form bilden ein Paar aus gerade/ungerade (VERB-SHORT `0x08`/VERB `0x09`). LABEL nimmt die Sprache als Sprach-Record im Object (UTF8-LANGUAGE-TEXT) auf und verwendet daher nur `0x04`.
- PUBLICATION, DEPRECATION und TOMBSTONE verwendet das Versionslisten-Dokument. Da die Versionsliste ohne Codebook lesbar sein muss, sind sie im Decoder eingebaut ([Ebene 0](/de/grammar/publishing/#ebenen) in der Veröffentlichungsadresse und Versionsliste).
- DECLARE, FIELD, ENUM und CODEC sind das Vokabular zum Schreiben von Codec-Spezifikationen. Da Spezifikationsdokumente ohne Codebook lesbar sein müssen, sind ihre Layouts im Decoder eingebaut (Ebene 0). Die mit diesem Vokabular geschriebenen Codec-Spezifikationsdokumente sind gewöhnliche Dokumente.

### TRIPLE

Details: [TRIPLE](/de/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Predicate         Reference (Wikidata-Eigenschaft usw.)
Subject           Reference
Object            Reference oder Value
Rank              1 WORD
```

| Rank | Name | Bedeutung |
|---|---|---|
| `0` | normal | Standard |
| `1` | preferred | Aktueller Wert, maßgeblichster Wert |
| `2` | deprecated | Als falsch oder veraltet beurteilter, aber als Aufzeichnung erhaltener Wert |

- Der Rank entspricht dem statement rank von Wikidata. Quellen, die keinen rank vergeben, verwenden `0`.
- **Die Bedeutung eines TRIPLE ist die Gesamtheit aller QUALIFIER, die auf seine Edge Id verweisen.** Der Leser sammelt die QUALIFIER, bevor er das TRIPLE interpretiert.

Beispiel: Q42 — P31 (instance of) — Q5 (Mensch), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Details: [QUALIFIER](/de/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id des eingeschränkten Edge)
Value             Reference oder Value
```

- Ein QUALIFIER ist Teil der Proposition. Er ist keine eigene Behauptung über die Proposition, sondern schränkt die Bedingungen ein, unter denen die Proposition wahr ist (Beginn/Ende, Geltungsbereich usw.).
- Eine eigene Behauptung über die Proposition (wer sie aufgestellt hat usw.) schreibt man als TRIPLE.
- Das Target ist ein Edge desselben Dokuments. Die Reihenfolge der QUALIFIER mit demselben Target ist die Reihenfolge im Dokument.

Beispiel: Q42 — P69 (educated at) — Q691283, Beginn (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Details: [LABEL](/de/grammar/edge/label/), [ALIAS](/de/grammar/edge/alias/), [DESCRIPTION](/de/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Name und Sprache stehen zusammen in einem Object (UTF8-LANGUAGE-TEXT).
- Zu demselben Subject und derselben Sprache gibt es höchstens ein LABEL. Weitere Namen schreibt man als ALIAS.
- Maschinennamen ohne Sprache schreibt man als BIND. LABEL muss eine Sprache haben.

### BIND

Details: [BIND](/de/grammar/edge/bind/)

- Bindet an das Subject einen Namen, auf den Maschinen abgestimmt werden (UTF8-TEXT). Er hat keine Sprache und wird nicht normalisiert. Nur bytegleiche Namen sind derselbe Name.
- Der Geltungsbereich des Namens ist das Dokument, das das BIND enthält. In einem Dokument wird derselbe Name nicht an verschiedene Subjects gebunden.
- Auf andere Records verweist man nicht über Namen, sondern über LOCAL IDs. Namen dienen dem Abgleich mit der Außenwelt (Host-Funktionen, Adresseingabe, Menschen).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Details: [SAME-NODE](/de/grammar/edge/same-node/), [DIFFERENT-NODE](/de/grammar/edge/different-node/), [REFERENCE-NODE](/de/grammar/edge/reference-node/)

- SAME-NODE ist die Identität: Zwei Reference verweisen auf dasselbe Objekt. Sie ist reflexiv, symmetrisch und transitiv.
- DIFFERENT-NODE ist die Nicht-Identität: Zwei Reference sind verschiedene Objekte.
- REFERENCE-NODE ist eine gerichtete Bindung, die per Object definiert, was das Subject (Reference) ist. Es ist keine Identitätsbehauptung. Beispiel: Es definiert die URI, auf die ein LOCAL-Knoten verweist.

## Beleg-Edges

Hängt Belege an einzelne Records im BODY oder an das gesamte Dokument (HEAD). Der einzige direkte Code der Belegfamilie ist [SOURCE](/de/grammar/edge/source/) (`0x20`).

| Codec | Name | Komponenten |
|---|---|---|
| `0x20` | [SOURCE](/de/grammar/edge/source/) | Target (Edge Id des BODY-Edge, an das der Beleg angehängt wird; im HEAD `0` = gesamtes Dokument), Origin (Quell-Reference, ABSENT oder UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- Eigenschaften der Quelle selbst (URL, Titel, Autor, Erscheinungsdatum …) schreibt man als TRIPLE mit der Quelle als Subject, Eigenschaften des Zitats (Abrufdatum, Stelle in der Quelle …) als QUALIFIER, der die Edge Id des SOURCE als Target hat.
- Die Quelle des gesamten Dokuments schreibt man im HEAD als SOURCE mit Target `0`, und auch die QUALIFIER, die dieses als Target haben, stehen im HEAD. Edges im HEAD sind nur diese beiden, und HEAD und BODY teilen sich einen Nummernraum für Edge Ids ([Quelle des gesamten Dokuments](/de/grammar/edge/source/#quelle-des-gesamten-dokuments)).
- Weitere Belege (Bereich im Originaltext, erzeugende Instanz, Konfidenz, Geltungszeitraum je Artikel, frühere Records) schreibt man als QUALIFIER, und die Version, in der etwas zuerst auftauchte, wird aus der Versionshistorie berechnet ([SOURCE](/de/grammar/edge/source/#darstellung-weiterer-belege)).
- Urteilsergebnisse auf Record-Ebene übernimmt TOULMIN `VERDICT`.

### SOURCE

Details: [SOURCE](/de/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id des BODY-Edge, an das der Beleg angehängt wird; im HEAD 0 = gesamtes Dokument)
Origin            Reference oder Slot-Marker 0x0000 ABSENT / 0x0001 UNKNOWN-VALUE
```

Beispiel: Quelle des Q42-P19-TRIPLE `#178` ist die Encyclopaedia Britannica (Q5375741), darin der Identifikator P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Ausführungs-Edges

Programmstrukturen, die nicht an eine bestimmte Programmiersprache gebunden sind. Die Komponenten werden über LOCAL IDs dieses Dokuments angesprochen.

| Gruppe | Codec |
|---|---|
| Deklaration | FUNCTION-DECLARE, TYPE-DECLARE |
| Ausdruck | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Anweisung | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Fehler | RAISE, TRY |

- Es ist kein Format, das Code einer fremden Sprache unverändert aufnimmt. Code fremder Sprachen legt man als Issuer-Format ab.
- Komponenten werden über LOCAL IDs (REF) dieses Dokuments angesprochen. An Stellen für Ausdrücke steht ein Ausdrucks-Edge oder ein Symbol. REF `0` bedeutet „kein“.
- Ausdrücke liefern einen Wert, Anweisungen nicht. Ein Ausdruck darf an der Anweisungsstelle eines BLOCK stehen (der Wert wird verworfen).
- Ein `for` im C-Stil schreibt man als BLOCK (Initialisierung, WHILE), ein `else if` als IF an der Stelle für „falsch“.
- Symbole sind LOCAL IDs, und der Name wird per BIND gebunden. Andere Records verweisen nicht über Namen, sondern über LOCAL IDs auf Symbole. Auch bei gleichem Namen sind Symbole mit verschiedener LOCAL ID verschieden.
- Was ein Symbol ist (Variable, Parameter, Funktion, Typ), bestimmt der Record, der auf das Symbol verweist. Symbole, für die es im Dokument keine Definition gibt, stellt die Außenwelt (Host) bereit; ist es das Ziel eines CALL, ist es eine Host-Funktion.

Offene Fragen: Operatorcodes, Typdarstellung, Payload-Layout der einzelnen Codecs.

## TOULMIN-Edges

Details: [TOULMIN](/de/grammar/edge/toulmin/)

Mit dem Toulmin-Argumentationsmodell werden Urteils- und Ausführungsgraphen geschrieben. Es ist die zentrale Familie, mit der GEUL die eigenen Regeln in GEUL beschreibt und sich selbst revidiert.

| Gruppe | Codec |
|---|---|
| Deklaration | CASE-DECLARE (Fall), [PREDICATE-DECLARE](/de/grammar/edge/toulmin/expr/) (Prädikat), SPEC-DECLARE (Beurteilungskriterium), RULE-DECLARE (Behauptung), COUNTER-DECLARE (Gegenbehauptung), EXCEPT-DECLARE (Ausnahme) — [NODE](/de/grammar/edge/toulmin/node/) |
| Beziehung | ATTACKS (Angriff), SUPERSEDES (Verdrängung) — [LINK](/de/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (Vorrangkette, Layout offen) |
| Ausführung | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/de/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/de/grammar/edge/toulmin/node/) |
| Ergebnis | VERDICT (Urteilsergebnis: Pass, Review, Fail), EVIDENCE (Beweis eines Urteils) — Layout offen |

- Originaltext, Gliederung sowie Hilfsknoten und -beziehungen sind ISSUER-Formate des GEUL-Issuers (`0xC000`~`0xC029`) ([SOURCE und Gliederung](/de/grammar/edge/toulmin/source/)).
- Urteilsergebnisse stehen in einem anderen Dokument als der Urteilsgegenstand. Das Ergebnisdokument importiert das Zieldokument und verweist darauf. Deshalb ändert sich der Inhaltshash des Zieldokuments durch das Urteil nicht.

## Issuer-Format-Edges

Ein Issuer kann eigene Edge-Formate definieren und verwenden (Codec `0x7C`~`0x7F`). Die direkten Codes `0x7C`~`0x7F` liegen zwar im TOULMIN-Bereich, sind aber gemeinsame ISSUER-Codes, und die Familie bestimmen die oberen 2 Bit der Formatnummer.

| Issuer | Formatnummer | Name | Familie |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/de/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/de/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/de/grammar/edge/toulmin/link/) | TOULMIN |
