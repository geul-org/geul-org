---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Mit dem Toulmin-Argumentationsmodell werden Beurteilungs- und Ausführungsgraphen geschrieben."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mit dem Toulmin-Argumentationsmodell werden Beurteilungs- und Ausführungsgraphen geschrieben. Es ist die Kernfamilie, mit der GEUL seine eigenen Regeln in GEUL beschreibt und sich selbst korrigiert.

| Gruppe | Codec |
|---|---|
| Deklaration | [CASE-DECLARE](0x100L-case-declare.md) (Fall), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (Prädikat), [SPEC-DECLARE](0x102L-spec-declare.md) (Beurteilungskriterium), [RULE-DECLARE](0x103L-rule-declare.md) (Behauptung), [COUNTER-DECLARE](0x104L-counter-declare.md) (Gegenbehauptung), [EXCEPT-DECLARE](0x105L-except-declare.md) (Ausnahme) — [NODE](#node) |
| Relation | [ATTACKS](0x108L-attacks.md) (Angriff), [SUPERSEDES](0x109L-supersedes.md) (Ausschluss) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (Prioritätskette, Layout noch offen) |
| Ausführung | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| Ergebnis | [VERDICT](0x118L-verdict.md) (Beurteilungsergebnis: Pass, Review, Fail), [EVIDENCE](0x119L-evidence.md) (Beleg der Beurteilung) — Layout noch offen |

- Originaltext, Gliederung sowie Hilfsknoten und -relationen sind die direkten Codes `0x120L~0x134L` der Familie TOULMIN-Format ([SOURCE und Gliederung](#source와-구획), [TOULMIN-Format](#toulmin-형식)).
- Das Beurteilungsergebnis steht in einem anderen Dokument als das Beurteilungsobjekt. Das Ergebnisdokument importiert das Zieldokument und verweist darauf. Deshalb ändert sich der Inhaltshash des Zieldokuments durch eine Beurteilung nicht.

Die Edges der TOULMIN-Familie (direkte Codes `0x100L~0x11BL`, Hilfs-Records in der Familie TOULMIN-Format `0x120L~0x134L`) schreiben Beurteilungs- und Ausführungsgraphen mit dem Toulmin-Argumentationsmodell. Die Deklaration von Behauptung, Gegenbehauptung und Ausnahme, Angriffs- und Ausschlussrelationen, Ausführungsverknüpfungen und Beurteilungsergebnisse sind allesamt Edges. Ein TANGEUL-Dokument (die Regelsprache der toulmin-Engine) wird zu einem GEUL-Dokument. Die Dateiendung ist wie bei anderen Dokumenten `.geul`.

Was dieses Dokument nicht festlegt, folgt den allgemeinen Regeln für [Edge](../edge/_index.md) und [Record und TAG WORD](../record.md).

## Metakognition und Selbstrevision {#메타-인지와-자기-개정}

TOULMIN ist ein GEUL-Codec, damit GEUL sich selbst metakognitiv erfassen kann. Nur wenn auch die Beurteilungs- und Ausführungsregeln in GEUL beschrieben sind, kann TOULMIN diese Regeln zum Gegenstand nehmen und sich selbst korrigieren. TOULMIN ist deshalb kein Anwendungsprofil, sondern der Kern des GEUL-Betriebs und liegt im direkten Code-Raum der Edges (`0x100L~0x11BL`).

- Selbstbeschreibung ermöglicht Selbstverbesserung, birgt aber das Risiko von Zirkelfehlern. Beurteilt eine Regel ihre eigene Revision selbst, kann auch eine Revision durchgehen, die das Beurteilungskriterium lockert (die Bestehensquote steigt, die tatsächliche Genauigkeit sinkt).
- Der Zirkel wird als Risiko akzeptiert, aber durch die Struktur unterbrochen.
  - **Fester Kern**: Die Bedeutung der Beurteilung (Pass, Review, Fail, Angriff, Ausschluss und Priorität, die dreiwertige Auswertung unter [Beurteilen auf Unbekanntem](#미상-위에서-판정하기) und U → Review) ist in dieser Spezifikation festgelegt. Ein TOULMIN-Dokument kann sie nicht ändern. Das ist derselbe Platz wie bei den im Decoder eingebauten Regeln (Schicht 0 in [Veröffentlichungsadresse und Versionsliste](../publishing.md#층)).
  - **Versionstrennung**: Die Revision des Regeldokuments v(n) wird mit den Regeln von v(n−1) und einer externen Prüfung beurteilt. Eine Regel beurteilt sich nicht selbst. Das Beurteilungsergebnis steht in einem anderen Dokument als das Objekt (der Inhaltshash des Objekts ändert sich nicht).
  - **Unveränderliche Historie**: Revisionen häufen sich als neue Versionen an (`PARENT`, Inhaltshash, Signatur). Da alte Versionen erhalten bleiben, lassen sich Zirkelfehler nachträglich finden und zurücknehmen. Das Sicherheitsnetz der Selbstrevision ist das Versionsmodell von GEUL ([Dokument](../document.md#개정)).
  - **Äußerer Maßstab**: Eine Sammlung von Testfällen, die der Revisionspfad nicht anfassen kann, wird gesondert geführt. Ob eine Revision übernommen wird, bestätigt das Ergebnis dieser Sammlung.
- Widerlegungstest: Man pflanzt absichtlich eine falsche Regel ein. Korrigiert das System sie und steigt der Punktwert des äußeren Maßstabs, funktioniert die Selbstverbesserung. Steigt nur die Bestehensquote und sinkt der Punktwert des äußeren Maßstabs, liegt ein Zirkelfehler vor.

## Code {#코드}

Ein TOULMIN-Record verwendet eines von drei Layouts. Das Layout bestimmt der Codec.

| Layout | Verwendung | Seite |
|---|---|---|
| NODE | Graphknoten wie Fall, Regel, Definition, Einstiegspunkt | [NODE](#node) |
| LINK | Relationen zwischen Knoten (Angriff, Ausschluss, Ausführung, Definition) | [LINK](#link) |
| EXPR | Bedingungsausdruck (Prädikat) | [EXPR](0x101L-predicate-declare.md) |

Die Records für Originaltext und Gliederung (SOURCE, TEXT, SECTION, CASE-BEGIN und CASE-END, PROSE) legt [SOURCE und Gliederung](#source와-구획) fest.

### Direkte Codes {#직접-코드}

| Codec | Name | Layout | TANGEUL | Bedeutung |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | Falldeklaration. Ein Beurteilungsgraph, der Knoten und Relationen enthält |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Bedingungsausdruck in Rules | Prädikatdeklaration. Beurteilungsausdruck |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Definitions-Einträge | Deklaration des Beurteilungskriteriums (Backing). Das role-Bit gibt die Art der Definition an |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, Regelname in Rules | Deklaration der Behauptung (Warrant). Kann angegriffen werden |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | Deklaration der Gegenbehauptung. Greift mit einer eigenen Schlussfolgerung an. Das Standard-Level ist Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | Ausnahmedeklaration. Greift ohne eigene Schlussfolgerung an. Das Standard-Level ist Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | Angriffsrelation. Die Beurteilung des Angreifers senkt die Beurteilung des Ziels schrittweise um die Angriffsstärke (0~1, Standard 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | Ausschlussrelation. Ist der Angreifer Active, nimmt er das Ziel deterministisch aus der Aggregation. Eine Kette (`A > B > C`) wird je Paar mit einem SUPERSEDES geschrieben |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | Prioritätskette `A > B > C`. Kurzform des paarweisen SUPERSEDES. Nur der Code ist vergeben; ein Layout gibt es noch nicht |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | Aktion, die ausgeführt wird, wenn der Knoten Active ist |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | Aktion, die auch bei Wiederholungsversuchen nur einmal ausgeführt wird |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | Kompensationsaktion (Saga) zu DO. Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | Verknüpfung, die ohne Nebenwirkungen nur beurteilt |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | Externer Einstiegspunkt. Führt einen Fall aus oder beurteilt ihn |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | Ereignis- oder periodischer Einstiegspunkt ohne externen Aufruf |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | Beurteilungsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Beurteilungswert, Activated, Excluded, Level. Nur der Code ist vergeben; ein Layout gibt es noch nicht |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | Beleg der Beurteilung. Position, Erwartungswert, Istwert (Fact). Nur der Code ist vergeben; ein Layout gibt es noch nicht |
| `0x11CL~0x11FL` | Reserved | | | |

- Die in der Tabelle nicht aufgeführten direkten Codes (`0x106L` und `0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL` und `0x11BL`) sind Reserved.
- Die Gruppen sind `0x100L~0x107L` Deklaration, `0x108L~0x10FL` Relation, `0x110L~0x117L` Ausführung und `0x118L~0x11FL` Ergebnis (`0x11CL~0x11FL` sind Reserved).
- Die Beurteilung des gesamten Dokuments übernimmt das Meta-[VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), die Beurteilung von Knoten und Records das TOULMIN-`VERDICT` (Edge `0x118L`). Beide sind getrennte Codecs mit unterschiedlichem Kind.

### TOULMIN-Format {#toulmin-형식}

Originaltext, Gliederung sowie Hilfsknoten und -relationen liegen in den direkten Codes `0x120L~0x134L` der Edge-Familie TOULMIN-Format. Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Andere Codes haben dieselbe Stelle
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference Record
Bestandteile      Layout, das das Format bestimmt
```

| Codec | Name | Layout | Bedeutung |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN-Breite-WORD, UTF8 Value | Originaltext des Autors |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | Name oder Zeichenkette |
| `0x122L` | [SECTION](0x122L-section.md) | ID, Abschnittscode 1 WORD | Beginn eines Abschnitts |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (Fall) | Beginn des Fallbereichs |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (Fall) | Ende des Fallbereichs |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | Prosaabsatz |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | Funktionsreferenz |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | geordnete Ausführungsgruppe |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | Fall → Feld |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | Definitionseintrag → Wert/Typ |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | Definitionseintrag → Feld |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | Einstiegspunkt → Fall, Ausführung |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | Einstiegspunkt → Fall, Beurteilung |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | Trigger → Fall |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | Trigger → Fall (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | Knoten → globaler Bezeichner |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | Alias → Pfad (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | Knoten → TEXT, Namensschreibweise |

## Dokument {#문서}

Eine `.geul`-Datei ist ein DOC. Außerhalb des DOC stehen keine weiteren Bytes.

```
DOC-1WORD/2WORD/4WORD     Gesamtlänge
  SPEC-VERSION            0x0001 (v1, Ganzzahl ohne eingebauten Value)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". Derzeit "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. Locale des Autors ("en", "ko")
BODY
  SOURCE                  Originaltext des Autors. Erster Record des BODY
  Satz-Records …          Reihenfolge der Dokumentdeklaration
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), optional [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- Der Decoder lehnt ab, wenn SPEC-VERSION abweicht oder das major von PROFILE abweicht. Weicht nur das minor ab, liest er trotzdem.
- Der erste Record des BODY ist SOURCE. Jeder SPAN ist ein Bereich in diesem Originaltext.
- Die Reihenfolge der Satz-Records entspricht der Deklarationsreihenfolge des Dokuments. Die Ausführungsreihenfolge (Auslösen von `do` und `run`, umgekehrte Kompensation bei `undo`) stützt sich auf diese Reihenfolge. Bei TOULMIN-Dokumenten hat die Edge-Reihenfolge Bedeutung (eine Ausnahme von der Reihenfolgeregel im [Edge-Layout](../edge/_index.md#레이아웃)).
- Alle Records des BODY sind Edges. Es gibt keine eigenständigen Value-Records. Werte sind in die Edge-Payload eingebettet.
- Identität und Import des Falls verwenden Meta-[DOC-ID](../meta/0x1C7L-doc-id.md) und [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject und See von TANGEUL).

## Gemeinsame Felder {#공통-필드}

| Feld | Breite | Beschreibung |
|---|---|---|
| ID | LOCAL Reference Record | Edge Id des Records. Erstes Element der Payload jedes Records |
| REF | LOCAL Reference Record | Edge Id, die auf einen anderen Record dieses Dokuments verweist. `0` bedeutet keine |
| SPAN | vom SOURCE bestimmte Breite × 2 | Bereich im Originaltext des Autors. Startbyte, Bytezahl |

- ID und REF sind eingebettete [LOCAL](../reference/0x005L-local.md)-Reference-Records (`0000 0000 0101 LLLL` + ID in kürzester Breite). Die Breite bestimmt das Length dieses Records und wird nicht je Dokument deklariert.
- REF `0` (LOCAL `0`) bedeutet „keine“. Das ist eine Codec-Regel, die LOCAL `0` als „keine“ verwendet ([LOCAL](../reference/0x005L-local.md)).
- Edge Ids werden ab 1 vergeben und dürfen im Dokument nicht doppelt vorkommen. `0` ist das „keine“ von REF und wird nicht als Edge Id verwendet.
- Auf Knoten verweisen andere Records vorwärts, daher erhalten sie ihre Nummern zuerst in der Deklarationsreihenfolge des Dokuments. Die übrigen Records (SOURCE, TEXT, LINK, FUNC, Gliederungs-Records) nummeriert der Encoder ab der Nummer nach den Knoten.
- Der Decoder prüft nur, dass die Edge Id nicht 0 ist und keine Duplikate vorkommen. Die Vergabereihenfolge verwendet er für die Interpretation nicht.
- Auf Knoten und Relationen wird per Edge Id verwiesen.
- Ein eingebetteter Value ist ein Value-Record einschließlich TAG WORD. Die Länge bestimmt dessen TAG.

## Zahlenwerte {#수치}

- Beurteilungswert (−1~1), Qualifier (0~1) und Angriffsstärke (0~1) sind [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Values. Ein eigenes Festkommaformat gibt es nicht.
- Der Encoder entfernt abschließende Nullen des Koeffizienten. 0.8 ist `C=8, E=−1`. Der Decoder akzeptiert bis zu vier Dezimalstellen.
- Ein Konfidenz-Gate (z. B. `at least 75%`) wird mit einem Vergleichsoperator von 1 WORD und einem Prozent-[UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md)-Value (`E=0`) geschrieben ([LINK](#link) F_GATE).
- Die Angriffsstärke ist das Feld F_FORCE von ATTACKS ([LINK](#공격-세기)). Liegt sie außerhalb des Bereichs, wird abgelehnt.

## Achsen der Knotendeklaration {#노드-선언의-축}

- Eine Knotendeklaration (RULE-, COUNTER-, EXCEPT-DECLARE) hat eine Rolle (Behauptung, Gegenbehauptung, Ausnahme), einen Qualifier (0~1) und ein Level (Unset, Fail, Review). Die Rolle tragen der Codec und das role im NODE-Header, den Qualifier F_QUAL, das Level das level im Header ([NODE](#node)).
- Die Stärke (Strict, Defeasible, Defeater) ist eine von der Rolle getrennte Achse. Wo die Stärke abgelegt wird, ist noch nicht festgelegt.
- Die Angriffsstärke (Force) ist der Wert einer ATTACKS-Kante, nicht eines Knotens ([LINK](#공격-세기) F_FORCE). Sie ist eine andere Achse als die Stärke.

## Beurteilen auf Unbekanntem {#미상-위에서-판정하기}

Erhält der Beurteilungsgraph GEUL-Fakten als Eingabe, werden die drei Begriffe des [Slot-Markers](../slot-marker.md) (nicht angegeben, unbekannt, nicht vorhanden) unterschiedlich ausgewertet. Die Vergleichsoperatoren von [EXPR](0x101L-predicate-declare.md) werden wie folgt ausgewertet.

| Eingabe | `is empty` | `is not empty` | `equals` / `is in` / Größenvergleich |
|---|---|---|---|
| Wert v | falsch | wahr | Auswertung mit v |
| NO-VALUE (nicht vorhanden) | **wahr** | falsch | falsch |
| UNKNOWN-VALUE (unbekannt) | falsch | **wahr** | **unbestimmt (U)** |
| ABSENT (nicht angegeben) / keine Aussage | U (offene Welt) | U | U |

- Die Logik verwendet die starke Kleene-Dreiwertigkeit. `NOT U = U`, `falsch AND U = falsch`, `wahr OR U = wahr`. Das U der übrigen Kombinationen ist U.
- `EXISTS any` ist wahr, wenn mindestens eines der Elemente wahr ist. Gibt es kein wahres, aber ein U, ist es U; sind alle falsch, ist es falsch.
- **Ist ein Prädikat U, ist die Beurteilung dieses Knotens nicht Pass oder Fail, sondern Review.** Was nicht bekannt ist, wird an einen Menschen (oder die nächste Stufe) übergeben.
- Soll ABSENT nicht als U, sondern als empty gelten, muss die Eingabeseite eine geschlossene Welt **deklarieren** (als Beurteilungskriterium SPEC eingespeist, z. B. „die Eingabe dieses Falls ist vollständig“). Ohne Deklaration ist es U.
- Diese Tabelle und die Zuordnung U → Review gehören zur Bedeutung der Beurteilung und sind damit der **feste Kern**. Ein TOULMIN-Dokument kann sie nicht ändern.
- Beispiel: Die Regel „zähle nur Grenzen, die heute noch gelten“ (`P582 is empty`) schließt bei P582 = UNKNOWN-VALUE aus, weil sie falsch ist, schließt bei P582 = NO-VALUE ein, weil sie wahr ist, und schickt bei fehlendem P582 an Review, weil sie U ist.

## Beurteilungsergebnis {#판정-결과}

- Das Beurteilungsergebnis (`VERDICT`, `EVIDENCE`) steht in einem anderen Dokument als das Beurteilungsobjekt. Das Ergebnisdokument importiert das Zieldokument mit [IMPORT-DOC](../meta/0x1E4L-import-doc.md) und verweist darauf mit [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). Deshalb ändert sich der Inhaltshash des Zieldokuments durch eine Beurteilung nicht.
- Die Beurteilung des gesamten Dokuments ist Meta-`VERDICT`, die von Knoten und Records TOULMIN-`VERDICT`.
- Auch die Regeln zur Wahl der anzuwendenden Fassung einer Revision (Übergangsvorschriften, Wahl zwischen dem zur Tatzeit geltenden und dem neuen Recht) sowie Auslegungsbeispiele und Präzedenzfälle dienen als Beurteilungsregeln ([Dokument](../document.md#개정)).

## Offene Probleme {#열린-문제}

- Die Layouts von SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`) und EVIDENCE (`0x119L`). Ob die jetzige Methode, SUPERSEDES paarweise zu schreiben, für eine Kette genügt.
- Die Ablage der Knotenstärke (Strict, Defeasible, Defeater).
- Ein ATTACKS mit angegebener Angriffsstärke 1 und eines ohne Angabe beurteilen gleich, haben aber unterschiedliche Bytes. Ob die Beurteilung gleich ist, muss am interpretierten Wert, nicht an den Bytes verglichen werden.
- Knotenzahl, Labelzahl und Label-Index in EXPR haben 1 WORD, die Kinderzahl 13 Bit. Die Obergrenzen sind fest.
- Das Layout von PROVENANCE (Herkunft und Prämissen von Regeln).
- Ob ein Name in Backticks statt als TEXT + LABEL (`0x134L`) als Aussage-[LABEL](../edge/0x0A4L-label.md) bzw. -[BIND](../edge/0x0A3L-bind.md) gesetzt wird.
- Die Tabelle der Codewerte für predicate und mode von Claim sowie der VerbCode-Codewerte von FuncRef.
- Ob die Deklaration der geschlossenen Welt (ABSENT als empty lesen) über das Beurteilungskriterium (SPEC) oder je Fall erfolgt.
- Das [Codec-Spezifikationsdokument](../codec-spec.md) der TOULMIN-Codecs. Die bedingten Felder von NODE und LINK sowie die vom SOURCE bestimmte SPAN-Breite sind Layouts, die sich nicht mit FIELD deklarieren lassen.

## Verwandte Seiten {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE und Gliederung](#source와-구획)
- [Dokument](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE ist das Layout, das einen Knoten des TOULMIN-Beurteilungs- und Ausführungsgraphen schreibt. Die Art des Knotens bestimmt der Codec; ein Header von 1 WORD bestimmt Rolle, Level, die Form des Claim und die bedingten Felder.

### Codec {#codec}

| Codec | Name | TANGEUL | Knoten |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | Fall |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Definitions-Einträge (`means`, `has`) | Beurteilungskriterium (Backing). role ist die Art der Definition |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | Behauptung (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | Gegenbehauptung (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | Ausnahme (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | Externer Einstiegspunkt |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | Ereignis- oder periodischer Einstiegspunkt |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | Dokument-Namensraum |
| `0x127L` | [FUNC](0x127L-func.md) | Funktionsreferenz | äußere Funktion (z. B. `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | Pflichtfeld |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | Alias des importierten Pakets |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` geordnete Liste | geordnete Ausführungsgruppe |

`0x126L~0x12AL` sind direkte Codes der Edge-Familie TOULMIN-Format ([TOULMIN](#toulmin-형식)).

### Layout {#레이아웃}

```
ID               LOCAL Reference Record (Edge Id)
Header 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | object-Art 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 falls nicht vorhanden) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(Fall)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. Anfangswert der Beurteilung
[F_WITH]         Anzahl (UNSIGNED-INTEGER Value) + REF(TEXT) × Anzahl
[F_GROUNDS]      Anzahl (UNSIGNED-INTEGER Value) + REF(TEXT) × Anzahl
SPAN             vom SOURCE bestimmte Breite × 2 (Startbyte, Bytezahl)
```

#### Header-WORD {#헤더-word}

| Bits | Feld | Wert |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | Eine Beleg-Liste ist vorhanden |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | object-Art | Form des Claim-object. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | siehe die folgende Tabelle |

| Bit | flag | Bedeutung |
|---|---|---|
| b0 | F_FUNC | Das Feld FuncRef ist vorhanden |
| b1 | F_QUAL | Das Feld Qualifier ist vorhanden |
| b2 | F_CHECK | Das Feld für den Fall des `checking` ist vorhanden |
| b3 | F_CLAIM | Das Feld Claim ist vorhanden |
| b4 | F_VERDICT | Das Feld für den Anfangswert der Beurteilung ist vorhanden |
| b5 | F_STRIKE | Eine durchgestrichene Deklaration. Hat kein Feld |
| b6 | F_WITH | Das Feld für die Kriterienliste ist vorhanden |

- Die bedingten Felder stehen in der Reihenfolge der flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Ein Feld mit ausgeschaltetem flag belegt keinen Platz.
- Ist ein flag gesetzt, aber das Feld fehlt, wird abgelehnt. Die Position nach dem Lesen der Felder muss hinter dem SPAN genau mit dem Ende des Records übereinstimmen.

### Felder {#필드}

| Feld | Beschreibung |
|---|---|
| FuncRef | Funktionsposition. REF ist der ALIAS-Record, der diese Funktion importiert hat; bei einer Funktion dieses Dokuments ist er `0`. VerbCode ist ein Code von 1 WORD und noch nicht vergeben (`0x0000` ist zulässig). Die Originalschreibweise der Funktion wird gesondert als TEXT + [LABEL](#link) geschrieben |
| Qualifier | Konfidenz des Knotens (0~1) |
| Fall | F_CHECK: der Fall, den dieser Knoten nur beurteilt (`checking c`) |
| Claim | Die vom Knoten getragene Proposition. subject REF, predicate 1 WORD, object, mode 1 WORD. Die Form von object bestimmt die object-Art im Header |
| Beurteilungswert | Anfangswert des Beurteilungswerts (−1~1) |
| F_WITH | Das Beurteilungskriterium zum Zeitpunkt der Deklaration (`기준으로 하는`, „zugrunde gelegt“). Liste von TEXT-Record-REFs |
| F_GROUNDS | Namen externer Fakten, die zum Auswertungszeitpunkt aufgelöst werden (`근거로 하는`, „gestützt auf“). Liste von TEXT-Record-REFs |
| SPAN | Bereich des Originaltexts, aus dem diese Deklaration stammt |

- Die Schreibweise von Beurteilungswert und Qualifier folgt den [TOULMIN](#수치)-Regeln für Zahlen.
- Die Anzahl in den Listen ist ein eingebetteter [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)-Value-Record.
- Die Grundform eines erzählenden Claim hat subject und predicate `0` und als object einen SPAN (object-Art 2). Er ist an die Schreibweise des Originaltexts gebunden.

### Interpretation und Gültigkeit {#해석과-유효성}

- role muss bei RULE-, COUNTER- und EXCEPT-DECLARE dem Codec entsprechen (0 general, 1 counter, 2 except). Bei SPEC-DECLARE ist es die Art der Definition. Bei allen anderen Codecs ist es 0.
- Ist level 0 (Unset), gilt der Standardwert der Engine: Fail bei COUNTER-DECLARE, Review bei EXCEPT-DECLARE.
- Die Host-Funktionsregel von TANGEUL `tangl:규칙` (`쓰는 규칙이다`, „ist eine Regel, die … verwendet“) wird als RULE-DECLARE NODE außerhalb eines Falls geschrieben. Die Funktion ist F_FUNC, das Kriterium F_WITH, der Beleg F_GROUNDS. Nur bei Bedingungsausdruck-Regeln steht davor ein [PREDICATE-DECLARE](0x101L-predicate-declare.md).
- Die Reserved-Bits (13–12) müssen 0 sein. Sind Reserved-Bits gesetzt oder passt role nicht zum Codec, wird abgelehnt.

### Verwandte Seiten {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE und Gliederung](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK ist das Layout, das im TOULMIN-Graphen Relationen zwischen Knoten schreibt. Die Art der Relation bestimmt der Codec.

### Codec {#codec-1}

| Codec | Name | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | Regel → Regel. Senkt die Beurteilung schrittweise um die Angriffsstärke |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | Regel → Regel. Ist er Active, nimmt er das Ziel aus der Aggregation |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | Regel → Fall |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | Regel → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | Regel → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | Regel → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | Regel → Fall. Beurteilung ohne Nebenwirkungen |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | Fall → Feld |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | Definitionseintrag → Wert/Typ |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | Definitionseintrag → Feld |
| `0x12EL` | [RUNS](0x12EL-runs.md) | Einstiegspunkt `run c` | Einstiegspunkt → Fall (Ausführung) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | Einstiegspunkt `check c` | Einstiegspunkt → Fall (Beurteilung) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | Trigger `run c` | Trigger → Fall |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | Trigger → Fall |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | Knoten → globaler Bezeichner |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | Alias → Pfad (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | Name in Backticks | Knoten → TEXT. Namensschreibweise |

### Layout {#레이아웃-1}

```
ID               LOCAL Reference Record (Edge Id)
src              REF
dst              REF. Bei DO, DO-ONCE und UNDO ein FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         Operator 1 WORD (obere 2 Bit) + UNSIGNED-DECIMAL Value (Prozent)
[F_FORCE]        SIGNED-DECIMAL Value. Angriffsstärke (0~1). Nur ATTACKS
SPAN             vom SOURCE bestimmte Breite × 2
```

| flag | Bedeutung |
|---|---|
| b0 F_ONCE | wird nur einmal ausgeführt (das `once` von UNDO) |
| b1 F_GATE | Das Feld für das Konfidenz-Gate ist vorhanden |
| b2 F_STRIKE | Eine durchgestrichene Relation |
| b3 F_ORDERED | Gehört zu einer geordneten Liste mit `1.` |
| b4 F_FORCE | Das Feld für die Angriffsstärke ist vorhanden. Nur ATTACKS |

| Gate-Operator | Bedeutung |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Die bedingten Felder stehen in der Reihenfolge der flags (F_GATE, F_FORCE). Ein Feld mit ausgeschaltetem flag belegt keinen Platz.

### Angriffsstärke {#공격-세기}

Die Angriffsstärke (F_FORCE) verwendet nur [ATTACKS](0x108L-attacks.md#공격-세기). Beurteilungsformel, Schreibweise und Beispiel stehen auf dieser Seite.

### Interpretation und Gültigkeit {#해석과-유효성-1}

- REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](#공통-필드)).
- Die Form von dst bestimmt der Codec. Bei DO, DO-ONCE und UNDO ist es ein FuncRef (REF(ALIAS, 0 falls nicht vorhanden) + VerbCode 1 WORD, [NODE](#필드)), bei LABEL und IMPORTED-FROM der REF eines TEXT-Records, bei den übrigen der REF eines Knotens.
- `do … once` wird vom Codec DO-ONCE ausgedrückt. In den flags von DO-ONCE wird F_ONCE nicht verwendet (ist es gesetzt, wird abgelehnt). Das `once` von UNDO wird mit F_ONCE geschrieben.
- Der Gate-Operator sind die oberen 2 Bit des Operator-WORD, die übrigen 14 Bit sind 0. Der Prozentwert ist ein UNSIGNED-DECIMAL Value mit `E=0` und liegt zwischen 0 und 100.
- Die Bits b5~b15 der flags sind Reserved und müssen 0 sein. Andernfalls wird abgelehnt.
- F_FORCE wird nur bei ATTACKS verwendet. Ist es bei einem anderen Codec (SUPERSEDES, Ausführungs- und Beurteilungsverknüpfungen, Relationen des TOULMIN-Formats) gesetzt, wird abgelehnt.
- Ist die Angriffsstärke kein SIGNED-DECIMAL Value, liegt sie außerhalb von 0~1 oder lässt sie sich nicht exakt mit vier Dezimalstellen darstellen, wird abgelehnt.
- Eine SUPERSEDES-Kette `A > B > C` wird paarweise mit je einem SUPERSEDES geschrieben.

### Verwandte Seiten {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE und Gliederung](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE und Gliederung {#source와-구획}

Records, die Originaltext und Gliederung eines TOULMIN-Dokuments schreiben. Alle sind direkte Codes `0x120L~0x125L` der Edge-Familie TOULMIN-Format ([TOULMIN](#toulmin-형식)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

### Format {#형식}

| Codec | Name | Layout |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN-Breite-WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, Abschnittscode 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (Fall) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (Fall) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](#공통-필드)).
- UTF8 Value ist ein [UTF8-TEXT](../value/0x072L-utf8-text.md)-Value-Record. Er enthält die Bytes unverändert.

### Seiten je Format {#형식별-쪽}

Layout, Tabelle der Abschnittscodes und Interpretation haben für jedes Format eine eigene Seite.

- [SOURCE](0x120L-source.md): Originaltext des Autors. Erster Record des BODY und bestimmt die SPAN-Breite
- [TEXT](0x121L-text.md): Name oder Zeichenkette
- [SECTION](0x122L-section.md): Beginn eines Abschnitts und Abschnittscode
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): Fallbereich
- [PROSE](0x125L-prose.md): Prosaabsatz

### Verwandte Seiten {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
