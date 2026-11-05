---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Ein Edge ist ein Record, der andere Records als Komponenten zu einer Aussage verbindet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Edge ist ein Record, der andere Records als Komponenten zu einer Aussage verbindet. Eine Aussage wie „Q42 ist ein Mensch“ oder „Der englische Name von Q42 ist Douglas Adams“ ist ein Edge.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Abschnitt 5~13 (0x0A0L~0x1BFL)
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]  bei Issuer-Format
Edge Id           LOCAL Reference-Record
Komponenten       in der vom Codec festgelegten Reihenfolge
```

- `LLLL` ist die Gesamtzahl der WORD einschließlich TAG WORD minus 1. Auch ohne Kenntnis des Codec springt der Decoder allein mit der Length zum nächsten Record.
- **Die erste Komponente ist stets die Edge Id (LOCAL Reference).** Da es ein LOCAL Reference ist (`0051` + ID, Identified `0x005L`), kann man die Edge Id auch ohne Kenntnis des Codec lesen.
- Jede Komponente findet ihre Grenze über ihre eigene Length. Die Position nach dem Lesen der letzten Komponente muss genau mit dem Ende des Edge übereinstimmen.
- Den Aufbau (Payload) der Komponenten legt das jeweilige Edge-Codec-Dokument fest.
- Bei Codecs mit Unterformaten (WORLD, TIMELINE, SCENE) bestimmt 1 WORD Codec-spezifischer TAG das Unterformat.
- Die Reihenfolge zwischen Edge-Records hat keine Bedeutung (außer wenn ein Codec sie eigens festlegt, z. B. im [TOULMIN](../toulmin/_index.md)-Dokument).
- Auf andere Edges verweist man über die Edge Id. Auf Edges dieses Dokuments mit LOCAL, auf Edges anderer Dokumente mit einem Zeiger-Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familien {#계열}

Der Edge-Bereich ist `0x0A0L~0x1BFL`. Die Familie eines direkten Codes ist `(Code − 0xA0) >> 5` (der Code sind die ersten drei Stellen der TAG ID). Familien umfassen je 32 Plätze und entsprechen dem Abschnitt `w >> 9` minus 5. Edge umfasst die Abschnitte 5~13.

| Abschnitt | Familie | Direkter Code | Aufgabe |
|---|---|---|---|
| 5 | Aussage | `0x0A0L~0x0BFL` | Baut Inhalte über Welt und Ereignisse auf |
| 6 | Beleg | `0x0C0L~0x0DFL` | Woher Records und Dokumente stammen ([SOURCE](0x0C0L-source.md)) |
| 7 | Ausführung | `0x0E0L~0x0FFL` | Ausführbare Programmstruktur (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | Argumentationsgraph: Behauptung, Gegenbehauptung, Ausnahme, Angriffsbeziehung, Ausführung, Beurteilungsergebnis |
| 9 | [TOULMIN](../toulmin/_index.md)-Format | `0x120L~0x134L` | Originaltext, Gliederung, Hilfsknoten und Beziehungen eines TOULMIN-Dokuments |

- Zugewiesen sind diese fünf Familien. `0x11CL~0x11FL` ist Reserved, ebenso `0x135L~0x1BCL` (die Abschnitte 10~12 sind insgesamt Reserved).
- `0x1BDL~0x1BFL` (die letzten drei Plätze von Abschnitt 13) ist EDGE-ISSUER (siehe Issuer-Format-Edge unten). Für Issuer-Formate gibt es keine Familienregel.

## Aussage-Edge {#서술-edge}

| Codec | Name | Komponenten |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Gerichtete Bindung: Subject (Reference) verweist auf Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | Zwei Reference verweisen auf dasselbe Ziel |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | Zwei Reference verweisen auf verschiedene Ziele |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Bindet einen maschinenlesbaren Namen (UTF8-TEXT) an das Subject |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Sprachabhängiger Name des Subject (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Anderer Name des Subject. Das Layout ist dasselbe wie bei LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Sprachabhängige Beschreibung des Subject. Das Layout ist dasselbe wie bei LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | Verbaussage |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | Eine Proposition (Predicate, Subject, Object) mit Rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | Eine Bedingung, die die Proposition eines anderen Edge einschränkt |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | Weltsicht, Ereignisfolge, Szenenstruktur |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | Veröffentlichung, Abkehr-Empfehlung und Löschung einer Dokumentversion ([Veröffentlichungsadresse und Versionsliste](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Vokabular zum Schreiben von Codec-Spezifikationen ([Codec-Spezifikationsdokument](../codec-spec.md)) |

- `-SHORT` und die Normalform bilden ein gerades/ungerades Paar (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). LABEL nimmt die Sprache als Sprach-Record im Object (UTF8-LANGUAGE-TEXT) auf und verwendet daher nur `0x0A4L`.
- PUBLICATION, DEPRECATION und TOMBSTONE werden vom Versionslisten-Dokument verwendet. Da die Versionsliste ohne Codebook lesbar sein muss, sind sie im Decoder eingebaut (Schicht 0 in [Veröffentlichungsadresse und Versionsliste](../publishing.md#층)).
- DECLARE, FIELD, ENUM und CODEC sind das Vokabular zum Schreiben von Codec-Spezifikationen. Da ein Spezifikationsdokument ohne Codebook lesbar sein muss, ist ihr Layout im Decoder eingebaut (Schicht 0). Die mit diesem Vokabular geschriebenen Codec-Spezifikationsdokumente sind gewöhnliche Dokumente.

### TRIPLE {#triple}

Details: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Predicate         Reference (Wikidata-Property usw.)
Subject           Reference
Object            Reference oder Value
Rank              1 WORD
```

| Rank | Name | Bedeutung |
|---|---|---|
| `0` | normal | Standard |
| `1` | preferred | Aktueller Wert, maßgeblichster Wert |
| `2` | deprecated | Als falsch oder veraltet beurteilter Wert, der als Aufzeichnung erhalten bleibt |

- Rank entspricht dem Statement-Rank von Wikidata. Quellen ohne eigene Rank-Vergabe verwenden `0`.
- **Die Bedeutung eines TRIPLE ist die Gesamtheit aller QUALIFIER, die auf seine Edge Id verweisen.** Der Leser sammelt die QUALIFIER, bevor er das TRIPLE interpretiert.

Beispiel: Q42 — P31 (instance of) — Q5 (Mensch), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Details: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id des eingeschränkten Edge)
Value             Reference oder Value
```

- Ein QUALIFIER ist Teil der Proposition. Er ist keine eigene Behauptung über die Proposition, sondern schränkt die Bedingungen ein, unter denen die Proposition wahr ist (Beginn- und Endzeitpunkt, Geltungsbereich usw.).
- Eine eigene Behauptung über die Proposition (z. B. wer sie aufgestellt hat) wird als TRIPLE geschrieben.
- Das Target ist ein Edge desselben Dokuments. Die Reihenfolge der QUALIFIER mit demselben Target ist ihre Reihenfolge im Dokument.

Beispiel: Q42 — P69 (educated at) — Q691283, Beginn (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Details: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Name und Sprache stehen gemeinsam in einem Object (UTF8-LANGUAGE-TEXT).
- Zu demselben Subject und derselben Sprache gibt es höchstens ein LABEL. Weitere Namen werden als ALIAS geschrieben.
- Ein maschinenlesbarer Name ohne Sprache wird als BIND geschrieben. Ein LABEL braucht eine Sprache.

### BIND {#bind}

Details: [BIND](0x0A3L-bind.md)

- Bindet einen Namen (UTF8-TEXT), auf den sich Maschinen abstimmen, an das Subject. Er hat keine Sprache und wird nicht normalisiert. Nur gleiche Bytes sind derselbe Name.
- Der Geltungsbereich des Namens ist das Dokument, das das BIND enthält. In einem Dokument wird derselbe Name nicht an verschiedene Subject gebunden.
- Andere Records werden nicht über den Namen, sondern über die LOCAL ID angesprochen. Der Name dient dem Abgleich mit der Außenwelt (Host-Funktionen, Adresseingaben, Menschen).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Details: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE ist die Identität, dass zwei Reference auf dasselbe Ziel verweisen. Sie ist reflexiv, symmetrisch und transitiv.
- DIFFERENT-NODE ist die Nichtidentität, dass zwei Reference verschiedene Ziele sind.
- REFERENCE-NODE ist eine gerichtete Bindung, die mit dem Object definiert, was das Subject (Reference) ist. Sie ist keine Identitätsbehauptung. Beispiel: Sie definiert den URI, auf den ein LOCAL-Knoten verweist.

## Beleg-Edge {#근거-edge}

Fügt einzelnen Records im BODY oder dem gesamten Dokument (HEAD) einen Beleg hinzu. Der direkte Code der Belegfamilie ist nur [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Name | Komponenten |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id des BODY-Edge, dem der Beleg hinzugefügt wird; im HEAD `0` = gesamtes Dokument), Origin (Ursprungs-Reference, ABSENT oder UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Eigenschaften der Quelle selbst (URL, Titel, Autor, Erscheinungsdatum …) werden als TRIPLE mit der Quelle als Subject geschrieben, Eigenschaften der Zitierung (Abrufdatum, Stelle innerhalb der Quelle …) als QUALIFIER mit der Edge Id des SOURCE als Target.
- Die Quelle des gesamten Dokuments wird im HEAD als SOURCE mit Target `0` geschrieben; auch der QUALIFIER, der dieses als Target hat, steht im HEAD. Nur diese beiden Edges kommen im HEAD vor, und HEAD und BODY teilen sich einen Edge-Id-Zahlenraum ([Herkunft des gesamten Dokuments](0x0C0L-source.md#문서-전체의-출처)).
- Andere Belege (Textbereich im Original, erzeugende Instanz, Vertrauenswürdigkeit, Geltungszeitraum je Vorschrift, alte Records) werden als QUALIFIER geschrieben, und die zuerst aufgenommene Version wird aus dem Versionsverlauf berechnet ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- Das Beurteilungsergebnis auf Record-Ebene übernimmt TOULMIN `VERDICT`.

### SOURCE {#source}

Details: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id des BODY-Edge, dem der Beleg hinzugefügt wird; im HEAD 0 = gesamtes Dokument)
Origin            Reference oder Slot-Marker 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Beispiel: Quelle des Q42-P19-TRIPLE `#178` ist Britannica (Q5375741), darin die Kennung P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Ausführungs-Edge {#실행-edge}

Programmstruktur, die an keine bestimmte Programmiersprache gebunden ist. Die Komponenten werden über LOCAL ID dieses Dokuments angesprochen.

| Gruppe | Codec |
|---|---|
| Deklaration | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| Ausdruck | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| Anweisung | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| Fehler | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- Dies ist kein Format, das Code einer fremden Sprache unverändert aufnimmt. Code fremder Sprachen wird im Issuer-Format abgelegt.
- Die Komponenten werden über die LOCAL ID (REF) dieses Dokuments angesprochen. Auf Ausdrucksplätzen stehen Ausdrucks-Edges oder Symbole. REF `0` bedeutet „nicht vorhanden“.
- Ein Ausdruck liefert einen Wert, eine Anweisung nicht. Ein Ausdruck darf auf einem Anweisungsplatz von BLOCK stehen (der Wert wird verworfen).
- Die C-Schleife `for` wird als BLOCK (Initialisierung, WHILE) geschrieben, `else if` als IF auf dem Falsch-Platz.
- Ein Symbol ist eine LOCAL ID, und sein Name wird mit BIND gebunden. Andere Records verweisen über die LOCAL ID auf das Symbol, nicht über den Namen. Auch bei gleichem Namen sind Symbole mit verschiedener LOCAL ID verschieden.
- Was ein Symbol ist (Variable, Parameter, Funktion, Typ), legt der Record fest, der auf das Symbol verweist. Ein Symbol ohne Definition im Dokument stellt die Außenwelt (der Host) bereit; ist es das Ziel eines CALL, ist es eine Host-Funktion.

Offene Probleme: Operatorcodes, Typdarstellung, Payload-Layout der einzelnen Codecs.

## TOULMIN-Edge {#toulmin-edge}

Mit dem Toulmin-Argumentationsmodell werden Beurteilungs- und Ausführungsgraphen geschrieben. Direkte Codes `0x100L~0x11BL`, Hilfs-Records gehören zur TOULMIN-Formatfamilie `0x120L~0x134L`. Details: [TOULMIN](../toulmin/_index.md)

## Issuer-Format-Edge {#issuer-형식-edge}

Ein Issuer kann eigene Edge-Formate definieren und verwenden ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)·[4WORD](0x1BEL-edge-issuer-4word.md)·[16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). Es sind die letzten drei Plätze des Edge-Bereichs. Der Codec-Erweiterungs-TAG enthält Issuer und Codec-Nummer in 2 WORD. Die Edge Id ist das erste Element des Payload danach (TAG, Issuer, Codec-Nummer, Edge Id, restlicher Payload). Die Codec-Nummer legt der Issuer fest; es gibt keine Familienregel. Unabhängig vom Kind überschneidet sie sich innerhalb des `codecs/` dieses Issuer nicht. Das Codec-Dokument liegt unter `codecs/` dieses Issuer, benannt nach der Codec-Nummer des Records ([Veröffentlichungsadresse und Versionsliste](../publishing.md)).

- Derzeit ist kein Edge-ISSUER-Format eingetragen.
